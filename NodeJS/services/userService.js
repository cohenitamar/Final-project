const Users = require('../models/Users').model;


const bcrypt = require('bcryptjs');
const Plans = require("../models/Plans").model;
const History = require("../models/History").model;
const Posts = require("../models/Posts").model;
const PersonalInformation = require("../models/PersonalInformations").model;
const Achievement = require('../models/Achievements').model;


async function changePassword(password, userID) {
    try {
        const hashedPassword = await bcrypt.hash(password, await bcrypt.genSalt(10));
        //console.log(await bcrypt.compare("ramirez", hashedPassword)); --comparing hash salt with the password

        await Users.findByIdAndUpdate(
            userID,
            {password: hashedPassword},
            {new: true}
        );

    } catch (e) {
        throw new Error(e);
    }
}


async function getUser(id) {
    try {

        var user = await Users.findOne({_id: id});
        if (!user) {
            throw new Error("User does not exist");
        }

        await user.populate('history');
        await user.populate('personalInformation');
        await user.populate('plans');
        await user.populate('posts');
        await user.populate('progress');
        await user.populate('achievements')
        return user;
    } catch (e) {
        throw new Error(e);
    }
}

async function createUser(id, req) {
    console.log(req.body)
    const pInfo = new PersonalInformation({
        userID: id,
        firstName: req.user.firebase.sign_in_provider === "password" ? req.body.firstName :
            req.user.name.split(" ")[0],
        lastName: req.user.firebase.sign_in_provider === "password" ? req.body.lastName :
            req.user.name.split(" ")[1],
        profilePic: req.user.firebase.sign_in_provider === "password" ? req.body.picture : req.user.picture,
        height: 0,
        weight: 0,
        bodyFat: 0,
        trainingsPerWeek: 0,
        doingAerobic: false,
        age: 0,
        gender: "N/A",
        occupation: "N/A",
        experienceLevel: "N/A",
        certifications: [],
        languages: [],
        specializations: [],
        socialAccounts: {}
    })
    const newPInfo = await pInfo.save();



    const achiev = new Achievement(
        {
            userID : id,
            maxWeight: 0,
            highestReps: 0,
            longestWorkoutDuration: 0,
            lowestBodyFatPercent: 0,
            totalWorkouts: 0,
            totalWeightLifted: 0,
            totalReps: 0,
            activeDays: 0,
            lastActiveDay: "N/A",
            totalWorkoutDuration: 0,
            longestWorkoutStreak:0,
            lastDayOfStreak: "N/A",

        }
    )
    const new_achiev = await achiev.save();

    const newUser = Users({
        _id: id,
        email: req.user.email,
        plans: [],
        history: [],
        posts: [],
        progress: [],
        personalInformation: newPInfo["_id"],
        achievements : new_achiev,
    })
    await newUser.save();
}


async function updateUser(id, info) {
    try {
        const filteredInfo = {
            profilePic: info.profilePic,
            height: info.height,
            weight: info.weight,
            bodyFat: info.bodyFat,
            trainingsPerWeek: info.trainingsPerWeek,
            doingAerobic: info.doingAerobic,
            age: info.age,
            gender: info.gender,
            occupation: info.occupation,
            experienceLevel: info.experienceLevel,
            certifications: info.certifications,
            languages: info.languages,
            specializations: info.specializations,
            socialAccounts: info.socialAccounts
        };

        const updateInfo = await PersonalInformation.findOneAndUpdate(
            {userID: id},
            filteredInfo,
            {new: true}
        );

        return updateInfo;

        if (!user) {
            throw new Error("User not found")
        }
        return user;
    } catch (e) {
        throw new Error(e);
    }
}


async function getUserById(id) {
    try {
        var user = await Users.findOne({_id: id}).populate('personalInformation');
        user = user['personalInformation'];
        console.log(user)
        if (!user) {
            throw new Error("User not found")
        }
        return {
            _id: id,
            firstName: user.firstName,
            lastName: user.lastName,
            profilePic: user.profilePic,
            age: user.age, // Assuming user object has an age property
            gender: user.gender, // Assuming user object has a gender property
            occupation: user.occupation, // Assuming user object has an occupation property
            experienceLevel: user.experienceLevel, // Assuming user object has an experienceLevel property
            certifications: user.certifications || [], // Assuming user object has certifications, default to an empty array if not present
            languages: user.languages || [], // Assuming user object has languages, default to an empty array if not present
            specializations: user.specializations || [], // Assuming user object has specializations, default to an empty array if not present
            socialAccounts: user.socialAccounts || {}
        };
    } catch (e) {
        console.log(e)
        throw new Error(e);
    }
}


async function deleteUser(id) {
    try {
        // Delete non-shared plans associated with the user
        await Plans.deleteMany({"userID": id, "isShared": false});

        // Delete all history associated with the user
        await History.deleteMany({"userID": id});

        // Delete personal information associated with the user
        await PersonalInformation.deleteOne({"userID": id});

        await Posts.deleteMany({"userID": id});

        // Delete the user
        await Users.deleteOne({"_id": id});

        return "User and associated data successfully deleted";
    } catch (e) {
        console.error("Error during user deletion:", e);
        throw new Error(`Failed to delete user: ${e.message}`);
    }
}


module.exports = {changePassword, getUser, getUserById, deleteUser, updateUser, createUser}
