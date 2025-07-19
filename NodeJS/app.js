const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const cors = require('cors');
const mongoose = require('mongoose');
require('custom-env').env(process.env.NODE_ENV, './config');

// Connect to MongoDB
mongoose.connect(process.env.CONNECTION_STRING, {
    useNewUrlParser: true,
    useUnifiedTopology: true
});

// Set request limits BEFORE routes
app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));

// Now import your routes
const plansRouter = require('./routes/plansRoute');
const userRouter = require('./routes/userRoute');
const socialRouter = require('./routes/socialRoute');
const statsRouter = require('./routes/statsRoute');



// Mount routes AFTER middleware
app.use('/api/plans', plansRouter);
app.use('/api/user', userRouter);
app.use('/api/social', socialRouter);
app.use('/api/stats', statsRouter);

// Start the server
server.listen(process.env.PORT, () => {
    console.log(`Server running on port ${process.env.PORT}`);
});
