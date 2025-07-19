const express = require('express');
const statsController = require('../controllers/statsController');
const authMiddleware = require("../firebase/authMiddleware");

var router = express.Router();

router.use(authMiddleware);


router.route('/')
    .get(statsController.getStats)
    .post(statsController.addStats)

router.route('/achievement')
    .post(statsController.updateAchievements)












module.exports = router;
