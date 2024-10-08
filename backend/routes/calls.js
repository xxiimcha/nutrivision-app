const express = require('express');
const router = express.Router();
const CallSignal = require('../models/CallSignal');

// Get call signals for the logged-in user (callee)
router.get('/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    // Fetch only the "calling" status signals for the receiver
    const calls = await CallSignal.find({
      receiverId: userId,   // Find by receiverId
      status: 'calling',    // Only get the "calling" status
    }).populate('callerId', 'name'); // Optionally populate caller's name or other details

    if (!calls.length) {
      return res.status(404).json({ msg: 'No incoming calls' });
    }

    res.status(200).json(calls);
  } catch (err) {
    console.error('Error fetching call signals:', err.message);
    res.status(500).send('Server error');
  }
});

// Update call status (e.g., "accepted", "declined")
router.post('/:callId/status', async (req, res) => {
  const { callId } = req.params;
  const { status } = req.body; // e.g., "accepted", "declined"

  if (!['calling', 'ringing', 'accepted', 'declined', 'missed', 'ended'].includes(status)) {
    return res.status(400).json({ msg: 'Invalid status' });
  }

  try {
    // Find the call by ID
    const call = await CallSignal.findById(callId);
    if (!call) {
      return res.status(404).json({ msg: 'Call not found' });
    }

    // Update the call's status
    call.status = status;
    await call.save();

    res.status(200).json({ msg: 'Call status updated', call });
  } catch (err) {
    console.error('Error updating call status:', err.message);
    res.status(500).send('Server error');
  }
});

module.exports = router;
