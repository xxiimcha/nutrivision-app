const express = require('express');
const router = express.Router();
const Notification = require('../models/Notification');

// Get notifications for a specific user
router.get('/:userId', async (req, res) => {
  try {
    const notifications = await Notification.find({ userId: req.params.userId }).sort({ createdAt: -1 });
    res.status(200).json(notifications);
  } catch (error) {
    console.error(`Error fetching notifications for user ${req.params.userId}:`, error);
    res.status(500).json({ message: 'Error fetching notifications', error });
  }
});

module.exports = router;
