const express = require('express');
const router = express.Router();
const Message = require('../models/Message');
const Admin = require('../models/Admin'); // Import the Admin model

// Fetch admin details by ID
router.get('/admin/:userId', async (req, res) => {
  try {
    const userId = req.params.userId;
    const admin = await Admin.findById(userId).lean();

    if (admin) {
      res.status(200).json({ name: `${admin.firstName} ${admin.lastName}` });
    } else {
      res.status(404).json({ error: 'Admin not found' });
    }
  } catch (error) {
    console.error(`Failed to fetch sender name for ${req.params.userId}: ${error}`);
    res.status(500).json({ error: 'Failed to fetch sender name' });
  }
});

// Fetch messages where the user is either the sender or the receiver
router.get('/:userId', async (req, res) => {
  try {
    // Find messages where the user is either the sender or the receiver
    const messages = await Message.find({
      $or: [{ sender: req.params.userId }, { receiver: req.params.userId }]
    }).sort({ timestamp: -1 }).lean(); // Convert to plain objects

    if (messages.length === 0) {
      return res.status(404).json({ message: 'No messages found' });
    }

    // For each message, fetch the corresponding admin details
    const messagesWithSenderNames = await Promise.all(
      messages.map(async (message) => {
        // Find the sender's name from the Admin collection
        const sender = await Admin.findById(message.sender).lean();
        return {
          ...message,
          senderName: sender ? sender.name : 'Unknown', // Include sender name in the response
        };
      })
    );

    res.status(200).json(messagesWithSenderNames);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch messages' });
  }
});


// Route to fetch conversation between two users
router.post('/conversation', async (req, res) => {
  const { loggedInUserId, otherUserId } = req.body;

  try {
    // Find messages where the sender or receiver is either loggedInUserId or otherUserId
    const messages = await Message.find({
      $or: [
        { sender: loggedInUserId, receiver: otherUserId },
        { sender: otherUserId, receiver: loggedInUserId }
      ]
    }).sort({ timestamp: 1 }); // Sort messages by timestamp (oldest to newest)

    res.status(200).json(messages);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch conversation' });
  }
});

// Route to send a new message
router.post('/send', async (req, res) => {
  const { sender, receiver, text } = req.body;

  // Validate that sender, receiver, and text are provided
  if (!sender || !receiver || !text) {
    return res.status(400).json({ error: 'Sender, receiver, and text are required' });
  }

  try {
    // Create a new message
    const newMessage = new Message({
      sender,
      receiver,
      text,
      timestamp: new Date() // Save the current date/time as the timestamp
    });

    // Save the message to the database
    await newMessage.save();

    // Return the saved message as a response
    res.status(200).json(newMessage);
  } catch (error) {
    console.error('Error sending message:', error);
    res.status(500).json({ error: 'Failed to send message' });
  }
});

module.exports = router;
