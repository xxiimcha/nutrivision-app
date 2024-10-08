const mongoose = require('mongoose');

const WeeklyImprovementSchema = new mongoose.Schema({
  patientId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'PatientRecord',
    required: true,
  },
  weekNumber: {
    type: Number,
    required: true,
  },
  improvement: {
    type: Number,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('WeeklyImprovement', WeeklyImprovementSchema);
