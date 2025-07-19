const admin = require('./firebaseConfig');

async function authMiddleware(req, res, next) {
    const authHeader = req.headers.authorization;

   if (authHeader && authHeader.startsWith('Bearer ')) {
        const idToken = authHeader.split('Bearer ')[1];
        try {
            // Verify the ID token
            const decodedToken = await admin.auth().verifyIdToken(idToken);
            console.log("decoded token: " + decodedToken)
            req.user = decodedToken;
            next();
        } catch (error) {
            console.error('Error verifying Firebase ID token:', error);
            return res.status(401).json({ error: 'Unauthorized', message: 'Invalid or expired token' });
        }
    } else {
        return res.status(401).json({ error: 'Unauthorized', message: 'No token provided' });
    }
}

module.exports = authMiddleware;
