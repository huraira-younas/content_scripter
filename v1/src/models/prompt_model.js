const mongoose = require("mongoose");

const promptModelSchema = new mongoose.Schema({
  adminId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    ref: "User",
  },
  defaultPrompt: {
    required: true,
    type: String,
  },
  model: {
    required: true,
    type: String,
  },
  modelApiKey: {
    required: true,
    type: String,
  },
  tagsApiKey: {
    required: true,
    type: String,
  },
});

const PromptModel = mongoose.model("PromptModel", promptModelSchema);
module.exports = PromptModel;
