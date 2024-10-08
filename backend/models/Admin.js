const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const AdminSchema = new Schema({
  firstName: {
    type: String,
    required: true
  },
  lastName: {
    type: String,
    required: true
  },
  email: {
    type: String,
    required: true,
    unique: true
  },
  password: {
    type: String,
    required: true
  },
  role: {
    type: String,
    required: true
  },
  otp: {
    type: String,
    required: false // OTP is not always required, so it's optional
  },
  otpExpires: {
    type: Date,
    required: false // Expiration time for the OTP
  },
  profilePicture: {
    type: String,
    required: false // Path to the profile picture, not required as default
  },
  status: {
    type: String,
    enum: ['active', 'inactive'], // Restricting status to either 'active' or 'inactive'
    default: 'active', // Default status is 'active'
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Admin', AdminSchema);
