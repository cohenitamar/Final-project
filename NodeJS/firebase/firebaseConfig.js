// firebaseConfig.js
const admin = require('firebase-admin');
const serviceAccount = require('./firebaseKey.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    // Optionally specify the database URL
    // databaseURL: 'https://your-database-name.firebaseio.com'
});

module.exports = admin;
