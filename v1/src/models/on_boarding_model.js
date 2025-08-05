const mongoose = require("mongoose");

const onBoardingSchema = new mongoose.Schema({
  adminId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    ref: "User",
  },
  index: {
    type: Number,
    required: true,
    unique: true,
  },
  imageUrl: {
    required: true,
    type: String,
    trim: true,
  },
  title: {
    required: true,
    unique: true,
    type: String,
    trim: true,
  },
  description: {
    required: true,
    type: String,
    trim: true,
  },
});

const OnBoarding = mongoose.model("OnBoarding", onBoardingSchema);
module.exports = OnBoarding;
