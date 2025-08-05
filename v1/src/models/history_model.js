const mongoose = require("mongoose");

const historySchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    ref: "User",
  },
  shared: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
  ],
  sessionId: {
    type: String,
    required: true,
  },
  pinned: {
    type: Boolean,
    default: false,
  },
  created: {
    type: Date,
    required: true,
  },
  iconUrl: {
    type: String,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
  text: {
    type: String,
    required: true,
  },
});

const History = mongoose.model("History", historySchema);
module.exports = History;
