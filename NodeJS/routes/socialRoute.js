const express = require('express');
const socialController = require('../controllers/socialController')
const authMiddleware = require("../firebase/authMiddleware");
var router = express.Router();


router.use(authMiddleware);



router.route('/')
    .get(socialController.getPlans)

router.route('/post')
    .get(socialController.getPosts)
    .post(socialController.createPost)

router.route('/share/:id')
    .get(socialController.sharePlan)

router.route('/post/delete/:id')
    .delete(socialController.deletePost)

router.route('/rate/up/:id')
    .get(socialController.rateUp);

router.route('/rate/down/:id')
    .get(socialController.rateDown);

router.route('/share/add/:id')
    .get(socialController.addSharedPlan)







module.exports = router;
