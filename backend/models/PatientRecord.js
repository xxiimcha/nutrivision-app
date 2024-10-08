const mongoose = require('mongoose');

const patientRecordSchema = new mongoose.Schema({
  referenceNumber: { type: String, unique: true, default: () => new mongoose.Types.ObjectId().toString() },
  address: String,
  guardian: String,
  name: String,
  dob: Date,
  gender: String,
  height: String,
  weight: String,
  dateOfWeighing: Date,
  ageInMonths: Number,
  weightForAge: String,
  heightForAge: String,
  weightForHeight: String,
  nutritionStatus: String,
  goalWeight: String,  // Add goalWeight here
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'Users', required: true }
});

module.exports = mongoose.model('PatientRecord', patientRecordSchema);
