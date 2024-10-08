const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const CallSignal = require('../models/CallSignal');  // Import the CallSignal model

// Endpoint to check for incoming calls
router.get('/check/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    // Check for any ongoing calls where the receiver is the user
    const call = await CallSignal.findOne({
      receiverId: mongoose.Types.ObjectId(userId),
      status: { $in: ['calling', 'ringing'] }, // Check for incoming/ringing calls
    }).sort({ timestamp: -1 });

    if (call) {
      res.json({
        hasIncomingCall: true,
        callerId: call.callerId,
        callType: call.callType,
      });
    } else {
      res.json({ hasIncomingCall: false });
    }
  } catch (err) {
    console.error(err);
    res.status(500).send('Error checking incoming call');
  }
});

// Endpoint to accept a call
router.post('/accept/:userId', async (req, res) => {
  const { userId } = req.params;
  const { callerId } = req.body;

  try {
    // Find the ongoing call and update its status to 'accepted'
    const call = await CallSignal.findOneAndUpdate(
      { callerId, receiverId: mongoose.Types.ObjectId(userId), status: 'ringing' },
      { $set: { status: 'accepted' } },
      { new: true }
    );

    if (call) {
      res.json({ success: true, message: 'Call accepted' });
    } else {
      res.status(404).json({ success: false, message: 'No matching call request' });
    }
  } catch (err) {
    console.error(err);
    res.status(500).send('Error accepting call');
  }
});

// Endpoint to decline a call
router.post('/decline/:userId', async (req, res) => {
  const { userId } = req.params;
  const { callerId } = req.body;

  try {
    // Find the ongoing call and update its status to 'declined'
    const call = await CallSignal.findOneAndUpdate(
      { callerId, receiverId: mongoose.Types.ObjectId(userId), status: 'ringing' },
      { $set: { status: 'declined' } },
      { new: true }
    );

    if (call) {
      res.json({ success: true, message: 'Call declined' });
    } else {
      res.status(404).json({ success: false, message: 'No matching call request' });
    }
  } catch (err) {
    console.error(err);
    res.status(500).send('Error declining call');
  }
});

module.exports = router;
