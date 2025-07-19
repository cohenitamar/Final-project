const registerController = require('../controllers/registerController');
const loginController = require('../controllers/loginController')
const express = require('express');
var router = express.Router();

router.route('/')
    .post(registerController.createUser);


router.route('/:id' )
    .get(loginController.getUser)



module.exports = router;
