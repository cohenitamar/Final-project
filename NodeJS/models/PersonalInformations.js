const mongoose = require('mongoose');
const {v4: uuidv4} = require('uuid');
const Schema = mongoose.Schema;

// Personal Information Schema
const PersonalInformation = new Schema({
    _id: {type: String, default: uuidv4},
    userID: {type: String, required: true, unique: true, index: true},
    firstName: {type: String, required: true},
    lastName: {type: String, required: true},
    profilePic: {type: String, required: true},
    height: {type: Number, required: true},
    weight: {type: Number, required: true},
    bodyFat: {type: Number, required: true},
    trainingsPerWeek: {type: Number, required: true},
    doingAerobic: {type: Boolean, required: true},
    age: {type: Number, required: true},
    gender: {type: String, required: true},
    occupation: {type: String, required: true},
    experienceLevel: {type: String, required: true},
    certifications: [{
        title: {type: String, required: true},
        link: {type: String, required: true},
    }],
    languages: [{type: String, required: true}],
    specializations: [{type: String, required: true}],
    socialAccounts: {type: Map, of: String, required: true},
});

const model = mongoose.model('PersonalInformations', PersonalInformation);
console.log('PersonalInformations model registered');
module.exports = {PersonalInformation, model};
