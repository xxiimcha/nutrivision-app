const express = require('express');
const router = express.Router();
const MealPlan = require('../models/MealPlan');
const moment = require('moment'); // Import moment for date formatting

// Create a new meal plan
router.post('/', async (req, res) => {
  try {
    const newMealPlan = new MealPlan(req.body);
    const savedMealPlan = await newMealPlan.save();
    res.status(201).json(savedMealPlan);
  } catch (error) {
    console.error('Error creating meal plan:', error);
    res.status(500).json({ message: 'Error creating meal plan', error });
  }
});

router.get('/:patientId/:week', async (req, res) => {
  try {
    const { patientId, week } = req.params;  // Extract patientId from req.params

    // Ensure patientId and week are valid
    if (!patientId) {
      return res.status(400).json({ message: 'Patient ID is required' });
    }

    if (!week) {
      return res.status(400).json({ message: 'Week is required' });
    }

    const mealPlan = await MealPlan.findOne({ patientId, week });

    if (!mealPlan) {
      // Return a default empty meal plan if not found
      const emptyMealPlan = {
        patientId, // Make sure to pass the patientId here
        week,
        Monday: { /* default structure */ },
        Tuesday: { /* default structure */ },
        // Rest of the days
      };

      return res.status(200).json(emptyMealPlan);
    }

    res.status(200).json(mealPlan);
  } catch (error) {
    console.error(`Error fetching meal plan for patient ${patientId}:`, error);
    res.status(500).json({ message: 'Error fetching meal plan', error });
  }
});

// Update a meal plan by patientId and week
router.put('/:patientId/:week', async (req, res) => {
  try {
    const { patientId, week } = req.params;
    const updatedMealPlan = await MealPlan.findOneAndUpdate(
      { patientId, week },
      req.body,
      { new: true, runValidators: true }
    );

    if (!updatedMealPlan) {
      return res.status(404).json({ message: 'Meal plan not found' });
    }

    res.status(200).json(updatedMealPlan);
  } catch (error) {
    console.error(`Error updating meal plan for patient ${req.params.patientId}:`, error);
    res.status(500).json({ message: 'Error updating meal plan', error });
  }
});

// Get all meal plans for a specific user
router.get('/:patientId', async (req, res) => {
  try {
    const { patientId } = req.params;
    const mealPlans = await MealPlan.find({ patientId });

    if (mealPlans.length === 0) {
      return res.status(404).json({ message: 'No meal plans found for this patient' });
    }

    res.status(200).json(mealPlans);
  } catch (error) {
    console.error(`Error fetching meal plans for patient ${req.params.patientId}:`, error);
    res.status(500).json({ message: 'Error fetching meal plans', error });
  }
});

router.post('/saveImageUrl', async (req, res) => {
  const { patientId, weekStartDate, day, mealType, imageUrl } = req.body;

  try {
    // Convert weekStartDate to the desired format (YYYY-MM-DD)
    const formattedWeekStartDate = moment(weekStartDate).format('YYYY-MM-DD');

    const fieldToUpdate = `${day}.${mealType}.photo`; // Path to the photo field

    console.log(`Updating image URL for:`);
    console.log(`Patient ID: ${patientId}`);
    console.log(`Formatted Week Start Date: ${formattedWeekStartDate}`);
    console.log(`Day: ${day}`);
    console.log(`Meal Type: ${mealType}`);
    console.log(`Field to Update: ${fieldToUpdate}`);
    console.log(`Image URL: ${imageUrl}`);

    // Find the document first and check if it exists
    const mealPlan = await MealPlan.findOne({ patientId, week: formattedWeekStartDate });
    if (!mealPlan) {
      console.log(`No meal plan found for patientId ${patientId} and week ${formattedWeekStartDate}`);
      return res.status(404).send('No meal plan found.');
    }

    // Attempt to update the photo field
    const updateResult = await MealPlan.updateOne(
      { patientId, week: formattedWeekStartDate },
      {
        $set: {
          [fieldToUpdate]: imageUrl, // Update the photo field
        }
      }
    );

    // Check if any document was updated
    if (updateResult.nModified === 0) {
      console.log('No document was updated. Possible incorrect field path or missing document.');
      return res.status(404).send('No document was updated. Possible incorrect field path or missing document.');
    }

    res.status(200).send('Image URL saved successfully.');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error saving image URL.');
  }
});

module.exports = router;
