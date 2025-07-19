const mongoose = require("mongoose");
const { v4: uuidv4 } = require('uuid');

const Schema = mongoose.Schema;

const Post = new Schema({
    _id: { type: String, default: uuidv4 },
    userID: { type: String, required: true, index: true },
    title: { type: String, required: true },
    content: { type: String, required: true },
    img: { type: String, required: true },
    creationDate: { type: String, required: true },
});

const model = mongoose.model('Posts', Post);
console.log('Posts model registered');
module.exports = { Post, model };
