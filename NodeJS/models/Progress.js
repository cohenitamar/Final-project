const mongoose = require('mongoose');
const {v4: uuidv4} = require('uuid');
const Schema = mongoose.Schema;

const Progress = new Schema({
    _id: {type: String, default: uuidv4},
    userID: {type: String, required: true},
    exercise: {type: String, required: true},
    dataByWeek: [{
        week: {type: Number, required: true},
        year: {type: Number, required: true},
        dataByDate: [{
            exerciseDetails: {
                reps: {type: Number, required: true},
                sets: {type: Number, required: true},
                weight: {type: Number, required: true}
            },
            date: {type: String, required: true},
        }]
    }]
});

const model = mongoose.model('Progress', Progress);
console.log('Progress model registered');
module.exports = {Progress, model};
