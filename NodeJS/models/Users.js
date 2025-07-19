const mongoose = require('mongoose');
const {v4: uuidv4} = require('uuid');
require('./PersonalInformations');
require('./History');
require('./Achievements');


const Schema = mongoose.Schema;
const User = new Schema({
    _id: {type: String, default: uuidv4},
    email: {type: String, required: true, unique: true},
    personalInformation: {
        type: String,
        ref: 'PersonalInformations'
    },
    plans: [{
        type: String,
        ref: 'Plans'
    }],
    history: [{
        type: String,
        ref: 'History'
    }],
    posts: [{
        type: String,
        ref: 'Posts'
    }],
    progress: [{
        type: String,
        ref: 'Progress'
    }]

    ,
    achievements:{
        type: String,
        ref: 'Achievement'
    },

});

const model = mongoose.model('Users', User);
console.log('Users model registered');

module.exports = {User, model};
