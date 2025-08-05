const mongoose = require("mongoose");

const featureSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
    unique: true,
  },
  fileInput: {
    image: {
      max: {
        type: Number,
        default: 5,
      },
      current: {
        type: Number,
        default: 0,
      },
    },
  },
  promptsLimit: {
    max: {
      type: Number,
      default: 50,
    },
    current: {
      type: Number,
      default: 0,
    },
  },
  resetDuration: {
    fileInput: {
      type: Number,
      default: 10800, // seconds
    },
    prompts: {
      type: Number,
      default: 18000, // seconds
    },
  },
});

const Feature = mongoose.model("Feature", featureSchema);
module.exports = Feature;
