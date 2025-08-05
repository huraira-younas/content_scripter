const mongoose = require("mongoose");

const messageSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  sessionId: {
    type: String,
    required: true,
  },
  time: {
    type: Date,
    required: true,
  },
  role: {
    type: String,
    required: true,
  },
  message: {
    type: String,
    required: true,
  },
  imageUrl: {
    type: String,
    default: null,
  },
});

const Message = mongoose.model("Message", messageSchema);
module.exports = Message;
