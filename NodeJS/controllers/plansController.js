const plansService = require('../services/plansService')
const Plans = require('../models/Plans').model;
const Users = require('../models/Users').model;


async function getPlans(req, res) {
    if (true) {
        const token = req.headers.authorization;
        var data;
        try {
            data = "user@example.com";
        } catch (error) {
            return res.status(401).json("Unauthorized");
        }
        let x = await plansService.getPlans("0f6e8d16-0b3c-4d1a-9b98-8d5e5a1b2dcb");
        if (x === -10) {
            return res.status(404).json("Error");
        }
        res.json(x);
    } else {
        return res.status(400).json("Bad Request");
    }
}

async function createPlan(req, res) {
    const request = req.body;
    const uid = req.user.uid;
    let newPlan = await plansService.createPlan(request, uid);
    return res.status(200).json(newPlan);


}

async function editPlan(req, res) {
    const plan = req.body
    // const searchedPlan = await Plans.findOne({_id: plan._id});
    // if (req.user.uid !== plan.userID && !searchedPlan['isShared'])
    //     return res.status(401).json("Unauthorized");
    let user = await Users.findOne({plans: plan._id});
    if (!user) {
        return res.status(400).json("Bad Request");
    }
    let newPlan = await plansService.editPlan(plan, user, req.user.uid);
    return res.status(200).json(newPlan);

}

async function deletePlanById(req, res) {
    const planId = req.params.id
    let user = await Users.findOne({plans: planId});
    if (!user) {
        return res.status(404).json("Resource not found");
    }
    if (user['_id'] !== req.user.uid) {
        return res.status(401).json("Unauthorized");
    }
    await plansService.deletePlanById(planId, user);
    return res.status(200)
}


module.exports = {getPlans, createPlan, editPlan, deletePlanById}
