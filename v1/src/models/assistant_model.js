const mongoose = require("mongoose");

const assistantSchema = new mongoose.Schema({
  adminId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    ref: "User",
  },
  icon: {
    type: String,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
  topic: {
    type: String,
    required: true,
  },
  prompt: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
});

const Assistant = mongoose.model("Assistant", assistantSchema);
module.exports = Assistant;
