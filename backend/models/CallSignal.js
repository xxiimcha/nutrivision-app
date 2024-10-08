// models/CallSignal.js
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const CallSignalSchema = new Schema({
  callerId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  receiverId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  status: { 
    type: String, 
    enum: ['calling', 'ringing', 'accepted', 'declined', 'missed', 'ended'], 
    default: 'calling' 
  },
  callType: { 
    type: String, 
    enum: ['audio', 'video'], // Call type can be either 'audio' or 'video'
    required: true 
  },
  timestamp: { type: Date, default: Date.now }
});

module.exports = mongoose.model('CallSignal', CallSignalSchema);