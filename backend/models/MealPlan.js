const mongoose = require('mongoose');

const mealSchema = new mongoose.Schema({
  mainDish: { type: String, default: '' },
  drinks: { type: String, default: '' },
  vitamins: { type: String, default: '' },
  photo: { type: String, default: '' },  // URL or path to the photo
  status: { type: String, enum: ['done', 'in-progress', ''], default: '' },
  approved: { type: Boolean, default: false },  // Add this field to track approval status
});

const daySchema = new mongoose.Schema({
  breakfast: mealSchema,
  lunch: mealSchema,
  dinner: mealSchema,
  recommended: { type: Boolean, default: false },
  status: { type: String, enum: ['done', 'in-progress', ''], default: '' },  // Status per day
});

const mealPlanSchema = new mongoose.Schema({
  patientId: { type: mongoose.Schema.Types.ObjectId, ref: 'Patient', required: true },
  week: { type: String, required: true }, // e.g., '2024-08-18'
  Monday: { type: daySchema, default: () => ({}) },
  Tuesday: { type: daySchema, default: () => ({}) },
  Wednesday: { type: daySchema, default: () => ({}) },
  Thursday: { type: daySchema, default: () => ({}) },
  Friday: { type: daySchema, default: () => ({}) },
  Saturday: { type: daySchema, default: () => ({}) },
  Sunday: { type: daySchema, default: () => ({}) },
}, {
  timestamps: true,
});

module.exports = mongoose.model('MealPlan', mealPlanSchema);


module.exports = mongoose.model('MealPlan', mealPlanSchema);
