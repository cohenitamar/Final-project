const Plans = require('../models/Plans').model;
const Users = require('../models/Users').model;
const Posts = require('../models/Posts').model;


async function getPlans() {
    try {
        const fetchedUsers = {};
        // Fetch shared plans from the database
        const plans = await Plans.find({isShared: true});

        const clonedPlans = [];

        for (let plan of plans) {
            // Check if we've already fetched this user's data
            if (!fetchedUsers[plan.userID]) {
                let userDoc = await Users.findOne({"_id": plan.userID});
                if (userDoc) {
                    await userDoc.populate('personalInformation');
                    const pi = userDoc.personalInformation;

                    // If personalInformation is missing or null, handle it gracefully
                    if (!pi) {
                        fetchedUsers[plan.userID] = {
                            firstName: '',
                            lastName: '',
                            profilePicture: '',
                            age: 0,
                            gender: '',
                            occupation: '',
                            experienceLevel: '',
                            certifications: [],
                            languages: [],
                            specializations: [],
                            socialAccounts: {},
                        };
                    } else {
                        fetchedUsers[plan.userID] = {
                            firstName: pi.firstName,
                            lastName: pi.lastName,
                            profilePicture: pi.profilePic,
                            age: pi.age,
                            gender: pi.gender,
                            occupation: pi.occupation,
                            experienceLevel: pi.experienceLevel,
                            certifications: pi.certifications,
                            languages: pi.languages,
                            specializations: pi.specializations,
                            socialAccounts: pi.socialAccounts,
                        };
                    }
                } else {
                    // Handle case where user isn't found at all
                    fetchedUsers[plan.userID] = {
                        firstName: '',
                        lastName: '',
                        profilePicture: '',
                        age: 0,
                        gender: '',
                        occupation: '',
                        experienceLevel: '',
                        certifications: [],
                        languages: [],
                        specializations: [],
                        socialAccounts: {},
                    };
                }
            }

            // Clone the plan and attach the user info
            const clonedPlan = {
                ...plan.toObject(),
                user: fetchedUsers[plan.userID]
            };
            clonedPlans.push(clonedPlan);
        }

        return clonedPlans;
    } catch (error) {
        throw new Error(error);
    }
}


async function rate(multiplicationFactor, planId, userID) {
    try {
        var plan = await Plans.findOne({_id: planId, isShared: true});
        if (plan['rating'] === 0 && multiplicationFactor === -1) {
            return;
        }
        console.log(plan)
        const rater = plan['raters'][userID];
        const up = multiplicationFactor === 1;
        const down = multiplicationFactor === -1;
        if (rater) {
            if ((multiplicationFactor === 1 && rater.up) || (multiplicationFactor === -1 && rater.down)) {
                return -1;
            }
            rater.up = up;
            rater.down = down;
        } else {
            plan['raters'][userID] = {up: up, down: down}
            console.log(plan)

        }
        plan['rating'] += multiplicationFactor;
        plan.markModified('raters');

        await plan.save();
        return plan;

    } catch (error) {
        return -10;
    }
}

async function getPosts() {
    try {
        const fetchedUsers = {};
        // Fetch posts from the database
        const posts = await Posts.find();

        // We'll create a new array and clone each post into it
        const clonedPosts = [];

        for (let post of posts) {
            // Check if we've already fetched this user's data
            if (!fetchedUsers[post.userID]) {
                let userDoc = await Users.findOne({"_id": post.userID});
                if (userDoc) {
                    await userDoc.populate('personalInformation');
                    const pi = userDoc.personalInformation;

                    // If personalInformation is missing or null, handle it gracefully
                    if (!pi) {
                        fetchedUsers[post.userID] = {
                            firstName: '',
                            lastName: '',
                            profilePicture: '',
                            age: 0,
                            gender: '',
                            occupation: '',
                            experienceLevel: '',
                            certifications: [],
                            languages: [],
                            specializations: [],
                            socialAccounts: {},
                        }
                    } else {
                        fetchedUsers[post.userID] = {
                            firstName: pi.firstName,
                            lastName: pi.lastName,
                            profilePicture: pi.profilePic,
                            age: pi.age,
                            gender: pi.gender,
                            occupation: pi.occupation,
                            experienceLevel: pi.experienceLevel,
                            certifications: pi.certifications,
                            languages: pi.languages,
                            specializations: pi.specializations,
                            socialAccounts: pi.socialAccounts,
                        }
                    }
                } else {
                    // Handle case where user isn't found at all, if necessary
                    fetchedUsers[post.userID] = {
                        firstName: '',
                        lastName: '',
                        profilePicture: '',
                        age: 0,
                        gender: '',
                        occupation: '',
                        experienceLevel: '',
                        certifications: [],
                        languages: [],
                        specializations: [],
                        socialAccounts: {},
                    }
                }
            }

            // Clone the post and attach the user info
            const clonedPost = {
                ...post.toObject(), // Ensure toObject() if needed to strip Mongoose methods
                user: fetchedUsers[post.userID]
            };
            clonedPosts.push(clonedPost);
        }

        return clonedPosts.reverse();
    } catch (error) {
        throw new Error(error);
    }
}

async function createPost(userID, post) {
    try {
        const user = await Users.findOne({'_id': userID});
        const newPost = new Posts({
                userID: userID,
                title: post.title,
                content: post.content,
                img: post.img,
                creationDate: post.creationDate,
            }
        )
        const savedPost = await newPost.save();
        user['posts'].push(savedPost['_id']);
        user.save();
        return savedPost['_id'];

    } catch (error) {
        return -10;
    }
}


async function deletePost(userID, postID) {
    try {
        const user = await Users.findOne({'_id': userID});
        const post = await Posts.findOne({'_id': postID})
        if (userID !== post.userID) {
            return;
        }
        user.posts.pull(postID)
        await user.save()
        await post.deleteOne();
        return "suc"
    } catch (e) {
        throw new Error(e);
    }
}


async function sharePlan(userID, planID) {
    try {
        var plan = await Plans.findOne({'_id': planID})
        if (userID !== plan.userID) {
            return;
        }
        plan['isShared'] = true;
        await plan.save();
    } catch (e) {
        throw new Error(e);
    }
}

async function addSharedPlan(userID, planID) {
    try {
        const user = await Users.findOne({'_id': userID});
        user['plans'].push(planID);
        await user.save()
    } catch (e) {
        throw new Error(e);
    }
}

module.exports = {rate, getPlans, getPosts, createPost, deletePost, sharePlan, addSharedPlan}





