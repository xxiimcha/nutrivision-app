const express = require('express');
const router = express.Router();
const PatientRecord = require('../models/PatientRecord');
const WeeklyImprovements = require('../models/WeeklyImprovements');

// Create a new patient record
router.post('/create', async (req, res) => {
  try {
    console.log('Received request body:', req.body);
    const { userId, ...patientData } = req.body;

    if (!userId) {
      console.log('userId is missing in the request body');
      return res.status(400).json({ message: 'userId is required' });
    }

    console.log('Extracted userId:', userId);
    console.log('Extracted patient data:', patientData);

    const newPatientRecord = new PatientRecord({
      ...patientData,
      userId,
    });

    await newPatientRecord.save();

    res.status(201).json(newPatientRecord);
  } catch (error) {
    console.error('Error creating patient record:', error);
    res.status(500).json({ message: 'Error creating patient record', error: error.message });
  }
});

// Get all patient records by userId
router.get('/:userId', async (req, res) => {
  try {
    const userId = req.params.userId;
    const patientRecords = await PatientRecord.find({ userId: userId });

    if (!patientRecords || patientRecords.length === 0) {
      return res.status(404).json({ message: 'No patient records found for this user' });
    }

    res.status(200).json({ patients: patientRecords });
  } catch (error) {
    console.error('Error fetching patient records:', error);
    res.status(500).json({ message: 'Error fetching patient records', error });
  }
});

// Get weekly improvements by patient ID
router.get('/weeklyimprovements/:patientId', async (req, res) => {
  const { patientId } = req.params;
  try {
    const improvementData = await WeeklyImprovements.findOne({ patientId });
    if (improvementData) {
      res.status(200).json(improvementData);
    } else {
      res.status(404).json({ message: 'No improvement data found for this patient.' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Server error.', error });
  }
});

module.exports = router;
