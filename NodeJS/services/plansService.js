const Plans = require('../models/Plans').model;
const Users = require('../models/Users').model;

async function getPlans(userID) {
    try {
        const user = await Users.findOne({'_id': userID}).populate('plans');
        return user['plans'];

    } catch (error) {
        return -10;
    }

}

async function createPlan(plan, userID) {
    try {
        const user = await Users.findOne({'_id': userID});
        const newPlan = new Plans({
                userID: userID,
                title: plan.title,
                subTitle: plan.subTitle,
                img: plan.img,
                creationDate: plan.creationDate,
                days: plan.days,
                rating: plan.rating,
                exercises: plan.exercises,
                isShared: plan.isShared,
                raters: {"N/A": {up: false, down: false}}
            }
        )
        const savedPlan = await newPlan.save();
        user['plans'].push(savedPlan['_id']);
        user.save();
        return savedPlan;

    } catch (error) {
        return -10;
    }
}

async function editPlan(plan, user, uID) {
    var searchedPlan = await Plans.findOne({_id: plan._id});
    if (!searchedPlan['isShared']) {
        const updatedPlan = await Plans.findByIdAndUpdate(
            plan['_id'],
            {
                title: plan.title,
                subTitle: plan.subTitle,
                img: plan.img,
                creationDate: plan.creationDate,
                days: plan.days,
                rating: plan.rating,
                exercises: plan.exercises,
                isShared: plan.isShared,
                raters: plan.raters
            },
            {new: true}
        );
        return updatedPlan;
    } else {
        const newPlan = new Plans({
                userID: uID,
                title: plan.title,
                subTitle: plan.subTitle,
                img: plan.img,
                creationDate: plan.creationDate,
                days: plan.days,
                rating: plan.rating,
                exercises: plan.exercises,
                isShared: plan.isShared,
                raters: plan.raters
            }
        )

        const response = await newPlan.save();
        for (var i = 0; i < user['plans'].length; i++) {
            var p = user['plans'][i];
            if (p === plan['_id']) {
                user['plans'][i] = response['_id'];
                break;
            }
        }
        user.save();
        return response;
    }
}

async function deletePlanById(planId, user) {
    try {
        const plan = await Plans.findOne({_id: planId})
        user.plans.pull(planId)
        user.save()
        if (!plan['isShared']) {
            plan.deleteOne();
        }
        return "suc"
    } catch (e) {
        throw new Error(e);
    }
}


/*
exercises: [{
    exercise: {
        name: ,
        category: ,
        img:
    } ,
    exerciseData: {
        reps: ,
        sets:,
        weight:,
    },
    checked:
}]
*/


module.exports = {getPlans, createPlan, editPlan, deletePlanById}

