const mongoose = require("mongoose");

const membershipPlanSchema = new mongoose.Schema({
  adminId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  isAdsOn: {
    type: Boolean,
    required: true,
  },
  fileInput: {
    image: {
      type: Number,
      required: true,
    },
  },
  promptsLimit: {
    max: {
      type: Number,
      required: true,
    },
  },
  resetDuration: {
    fileInput: {
      type: Number,
      required: true,
    },
    prompts: {
      type: Number,
      required: true,
    },
  },
  features: {
    type: [String],
    required: true,
  },
});

const MembershipPlan = mongoose.model("MembershipPlan", membershipPlanSchema);
module.exports = MembershipPlan;
