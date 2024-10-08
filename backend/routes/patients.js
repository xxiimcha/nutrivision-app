const express = require('express');
const router = express.Router();
const PatientRecord = require('../models/PatientRecord');

// Create a new patient record
router.post('/create', async (req, res) => {
  try {
    // Log the entire request body to verify if it's being received correctly
    console.log('Received request body:', req.body);

    const { userId, ...patientData } = req.body;

    // Validate the userId
    if (!userId) {
      console.log('userId is missing in the request body');
      return res.status(400).json({ message: 'userId is required' });
    }

    // Log the extracted userId and patientData to verify
    console.log('Extracted userId:', userId);
    console.log('Extracted patient data:', patientData);

    // Create a new patient record
    const newPatientRecord = new PatientRecord({
      ...patientData,
      userId,
    });

    // Save the new patient record to the database
    await newPatientRecord.save();

    // Send a successful response with the new patient record
    res.status(201).json(newPatientRecord);
  } catch (error) {
    // Log the full error for debugging purposes
    console.error('Error creating patient record:', error);

    // Send an error response
    res.status(500).json({ message: 'Error creating patient record', error: error.message });
  }
});

// Get all patient records by userId
router.get('/:userId', async (req, res) => {
  try {
      const userId = req.params.userId;

      // Use find to get all patient records for the user
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

module.exports = router;
