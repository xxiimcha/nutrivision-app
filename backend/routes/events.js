const express = require('express');
const Event = require('../models/Event'); // Import the Event model

const router = express.Router();

// Get events by date (or all events if no date is provided)
router.get('/', async (req, res) => {  // Notice the change here
  const { date } = req.query;

  try {
    const query = date ? { date: new Date(date) } : {};
    const events = await Event.find(query);
    res.status(200).json(events);
  } catch (err) {
    console.error('Error fetching events:', err.message);
    res.status(500).send('Server error');
  }
});

module.exports = router;
