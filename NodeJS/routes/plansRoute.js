const plansController = require('../controllers/plansController');

const express = require('express');
const authMiddleware = require("../firebase/authMiddleware");
var router = express.Router();


router.use(authMiddleware);

router.route('/')
    .get(plansController.getPlans)

router.route('/create')
    .post(plansController.createPlan)

router.route('/edit')
    .post(plansController.editPlan)


router.route('/delete/:id')
    .delete(plansController.deletePlanById)






module.exports = router;
