const mongoose = require('mongoose');
const {v4: uuidv4} = require('uuid');
const Schema = mongoose.Schema;

const History = new Schema({
    _id: {type: String, default: uuidv4},
    userID: {type: String, required: true},
    title: {type: String, required: true},
    executionDate: {type: String, required: true},
    duration: {type: String, required: true},
    exercises: [{
        name: {type: String, required: true},
        img: {type: String, required: true},
        category: {type: String, required: true},
        exerciseDetails: {
            reps: {type: Number, required: true},
            sets: {type: Number, required: true},
            weight: {type: Number, required: true}
        },
        checked: {type: Boolean, required: true},
    }]
});

const model = mongoose.model('History', History);
console.log('History model registered');
module.exports = {History, model};
