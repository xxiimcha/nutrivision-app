const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();

const fs = require('fs');
const uploadDir = './uploads';

// Check if the 'uploads' directory exists, if not, create it
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir);
}

// Middleware
app.use(bodyParser.json());
app.use(cors());

// MongoDB connection
mongoose.connect('mongodb+srv://nutrivision:nutrivision123@nutrivision.04lzv.mongodb.net/nutrivision?retryWrites=true&w=majority&appName=nutrivision', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Routes
const authRoutes = require('./routes/auth'); // Import the auth routes
const eventRoutes = require('./routes/events'); // Import the event routes
const patientRoutes = require('./routes/patients'); // Import the patient routes
const userRoutes = require('./routes/users'); // Import the patient routes
const notifRoutes = require('./routes/notifications'); // Import the patient routes
const mealPlanRoutes = require('./routes/mealplans'); // Import the patient routes
const messagesRouter = require('./routes/messages'); // Correct path to your messages route file
app.use('/api/messages', messagesRouter); // Use '/api/messages' as the base path for message routes
const callsRouter = require('./routes/calls'); // Correct path to your messages route file
app.use('/api/calls', callsRouter); // Use '/api/messages' as the base path for message routes

app.use('/api/auth', authRoutes); // Use the auth routes
app.use('/api/events', eventRoutes); // Use the event routes
app.use('/api/patients', patientRoutes); // Use the patient routes
app.use('/api/users', userRoutes); // Use the patient routes
app.use('/api/notifications', notifRoutes); // Use the patient routes
app.use('/api/mealplans', mealPlanRoutes); // Use the patient routes

// Set the port to 5000
const PORT = 5000;

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
