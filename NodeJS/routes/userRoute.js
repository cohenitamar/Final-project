const express = require('express');
const router = express.Router();
const authMiddleware = require('../firebase/authMiddleware');

const userController = require("../controllers/userController");


router.use(authMiddleware);

router.route('/')
    .get(userController.getUser)
    .delete(userController.deleteUser)
    .post(userController.updateUser);

router.route('/change-password')
    .post(userController.changePassword);

router.route('/create')
    .post(userController.createUser);



module.exports = router;
