const express = require('express');
const User = require('../models/Users');
const router = express.Router();

router.post('/', async (req, res) => {
  const { identifier, password } = req.body;
  let user;

  try {
    if (identifier.includes('@')) {
      user = await User.findOne({ email: identifier });
    } else {
      user = await User.findOne({ username: identifier });
    }

    if (!user) {
      console.log('User not found for identifier:', identifier);
      return res.status(401).json({ status: 'fail', message: 'Invalid credentials' });
    }

    console.log('User found:', user);
    console.log('Entered password:', password);
    console.log('Stored password:', user.password);

    if (user.password === password) {
      console.log('User ID:', user._id);  // Log the user ID
      res.status(200).json({ status: 'success', userId: user._id }); // Return user ID in the response
    } else {
      res.status(401).json({ status: 'fail', message: 'Invalid credentials' });
    }
  } catch (error) {
    console.log('Error during login:', error);
    res.status(500).json({ status: 'error', message: 'An error occurred' });
  }
});

module.exports = router;
