const mongoose = require("mongoose");
const {v4: uuidv4} = require('uuid');

const Schema = mongoose.Schema;

const Achievement = new Schema({
    _id: {type: String, default: uuidv4},
    userID :{type: String, required: true},
    maxWeight: {type: Number, required: true},
    highestReps: {type: Number, required: true},
    longestWorkoutDuration: {type: Number, required: true},
    totalWorkouts: {type: Number, required: true},
    totalWeightLifted: {type: Number, required: true},
    totalReps: {type: Number, required: true},
    activeDays: {type: Number, required: true},
    lastActiveDay: {type: String, required: true},
    totalWorkoutDuration: {type: Number, required: true},
    longestWorkoutStreak :{type: Number, required: true},
    lastDayOfStreak : {type: String, required: true},
    lowestBodyFatPercent :{type: Number, required: true},


});

const model = mongoose.model('Achievement', Achievement);
console.log('Achievements model registered');

module.exports = {Achievement, model};
