const socialService = require('../services/socialService')
const plansService = require("../services/plansService");


async function getPlans(req, res) {
    let x = await socialService.getPlans();
    res.json(x);
}


async function rateUp(req, res) {
    const planId = req.params.id
    let x = await socialService.rate(1, planId, req.user.uid);
    res.json(x);
}

async function rateDown(req, res) {
    const planId = req.params.id
    let x = await socialService.rate(-1, planId, req.user.uid);
    res.json(x);
}


async function getPosts(req, res) {
    let x = await socialService.getPosts();
    res.json(x);
}


async function createPost(req, res) {
    const post = req.body
    let x = await socialService.createPost(req.user.uid, post);
    res.send(x);
}


async function deletePost(req, res) {
    const postID = req.params.id
    let x = await socialService.deletePost(req.user.uid, postID);
    res.json(x);
}


async function sharePlan(req, res) {
    const planId = req.params.id
    let x = await socialService.sharePlan(req.user.uid, planId);
    res.send(x);
}

async function addSharedPlan(req, res) {
    const planId = req.params.id
    let x = await socialService.addSharedPlan(req.user.uid, planId);
    res.send(x);
}

module.exports = {getPlans, getPosts, rateUp, rateDown, createPost, deletePost, sharePlan, addSharedPlan}
