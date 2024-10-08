const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  firstName: {
    type: String,
    required: false, // Initially not required, can be updated later
  },
  lastName: {
    type: String,
    required: false, // Initially not required, can be updated later
  },
  otp: {
    type: String,
    required: false,
  },
  otpExpires: {
    type: Date,
    required: false,
  },
});

const User = mongoose.model('User', UserSchema);
module.exports = User;
