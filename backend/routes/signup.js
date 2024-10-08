const express = require('express');
const User = require('../models/Users'); // Ensure this path is correct based on your project structure
const router = express.Router();
const crypto = require('crypto');
const nodemailer = require('nodemailer');
const bcrypt = require('bcrypt');

router.post('/signup', async (req, res) => {
  const { username, email, password } = req.body;

  try {
    // Check if the user already exists
    let user = await User.findOne({ email });
    if (user) {
      console.log(`Signup attempt failed: User with email ${email} already exists.`);
      return res.status(400).json({ status: 'fail', message: 'User already exists' });
    }

    // Hash the password before saving it
    const hashedPassword = await bcrypt.hash(password, 10);

    // Generate OTP
    const otp = crypto.randomBytes(3).toString('hex'); // Generate a 6-character OTP
    const otpExpires = Date.now() + 10 * 60 * 1000; // OTP expires in 10 minutes

    // Create a new user with the OTP and its expiration time
    user = new User({ username, email, password: hashedPassword, otp, otpExpires });
    await user.save();

    console.log(`User ${username} registered successfully. OTP generated.`);

    // Send OTP to the user's email
    const transporter = nodemailer.createTransport({
      service: 'Gmail', // Replace with your email service
      auth: {
        user: 'charmaine.l.d.cator@gmail.com', // Replace with your email
        pass: 'uupdlgytovgrljdn', // Replace with your email password
      },
    });

    const mailOptions = {
      from: 'charmaine.l.d.cator@gmail.com',
      to: email,
      subject: 'Your OTP Code',
      text: `Your OTP code is ${otp}. It will expire in 10 minutes.`,
    };

    await transporter.sendMail(mailOptions);
    console.log(`OTP email sent successfully to ${email}.`);

    res.status(201).json({ status: 'success', message: 'User registered successfully. OTP sent to your email.' });
  } catch (error) {
    console.error('Error during signup:', error); // Log the error for debugging
    res.status(500).json({ status: 'fail', message: 'Server error' });
  }
});

module.exports = router;
