const Users = require('../models/Users').model;
const userService = require('../services/userService');
const plansService = require("../services/plansService");
const admin = require('../firebase/firebaseConfig');

async function changePassword(req, res) {
    if (true) {
        const password = req.body.password;
        var userID = "";
        try {
            await userService.changePassword(password, "0f6e8d16-0b3c-4d1a-9b98-8d5e5a1b2dcb");
        } catch (e) {
            return res.status(400).json(e);
        }
    } else {
        return res.status(400).json("Bad Request");
    }
}

async function getUser(req, res) {
    try {
        const uid = req.user.uid;
        let response = await userService.getUser(uid);
        return res.status(200).json(response);
    } catch (e) {
        console.error('Error fetching user data:', e);
        return res.status(500).json({ error: 'Internal Server Error', details: e.toString() });
    }
}


async function createUser(req, res) {
    try {
        const uid = req.user.uid;
        let response = await userService.createUser(uid, req);
        return res.status(200).json("Created user");
    } catch (e) {
        console.error('Error fetching user data:', e);
        return res.status(500).json({ error: 'Internal Server Error', details: e.toString() });
    }
}



async function getUserById(req, res) {
    if (true) {
        const id = req.params.id
        if (id) {

            try {
                //aturization and also check if id from token is the same as user id
                response = await userService.getUserById(id);
                return res.status(200).json(response);


            } catch (e) {
                return res.status(400).json(e);
            }
        } else {
            return res.status(400).json("Bad Request");
        }


    } else {
        return res.status(400).json("Bad Request");

    }
}


async function deleteUser(req, res) {
    if (true) {
        try {
            await userService.deleteUser("0f6e8d16-0b3c-4d1a-9b98-8d5e5a1b2dcb");

            return res.status(200)

            //aturization
        } catch (e) {
            return res.status(400).json("Error " + e.toString());
        }
        if (newPlan === -10) {
            return res.status(404).json("Error");
        }
        return res.status(200).json(newPlan);
    } else {
        return res.status(400).json("Bad Request");

    }
}


async function updateUser(req, res) {
    if (true) {
        const info = req.body
        const id = req.user.uid;
        if (id) {
            try {
                //aturization and also check if id from token is the same as user id
                response = await userService.updateUser(id,info);
                return res.status(200).json(response);


            } catch (e) {
                return res.status(400).json(e);
            }
        } else {
            return res.status(400).json("Bad Request");
        }


    } else {
        return res.status(400).json("Bad Request");

    }
}



module.exports = {getUser, changePassword, getUserById, deleteUser,updateUser, createUser}

