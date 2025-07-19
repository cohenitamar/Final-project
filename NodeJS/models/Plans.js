const mongoose = require('mongoose');
const {v4: uuidv4} = require('uuid');
const Schema = mongoose.Schema;

const Plan = new Schema({
    _id: {type: String, default: uuidv4},
    userID: {type: String, required: true},
    title: {type: String, required: true},
    subTitle: {type: String, required: true},
    img: {type: String, required: true},
    creationDate: {type: String, required: true},
    days: [{type: String, required: true}],
    rating: {type: Number, required: true},
    exercises: [{
        name: {type: String, required: true, index: true},
        img: {type: String, required: true},
        category: {type: String, required: true},
        exerciseDetails: {
            reps: {type: Number, required: true},
            sets: {type: Number, required: true},
            weight: {type: Number, required: true}
        },
        checked: {type: Boolean, required: true},
    }],
    isShared: {type: Boolean, required: true},
    raters: {
        type: Object,
        required: true,
        default: () => ({})
    },
});

const model = mongoose.model('Plans', Plan);
console.log('Plans model registered');
module.exports = {Plan, model};
