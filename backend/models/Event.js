const mongoose = require('mongoose');

const eventSchema = new mongoose.Schema({
  title: { type: String, required: true },
  location: { type: String, required: true },
  date: { type: Date, required: true },  // Date of the event
  time: { type: String, required: true }, // Time in HH:mm format
  recipient: { type: String, required: true }, // e.g., 'all', 'admin', 'users'
  status: { type: String, enum: ['upcoming', 'completed', 'cancelled'], default: 'upcoming' }, // Event status
}, {
  timestamps: true, // Automatically adds createdAt and updatedAt timestamps
});

const Event = mongoose.model('Event', eventSchema);

module.exports = Event;
