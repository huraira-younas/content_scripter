const mongoose = require("mongoose");

const membershipAllActivitySchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  timestamp: {
    type: Date,
    default: Date.now,
  },
  planTitle: {
    type: String,
    required: true,
  },
  totalAmount: {
    type: Number,
    required: true,
  },
  planType: {
    type: String,
    enum: ["upgrade", "subscription"],
  },
});

const MembershipAllActivity = mongoose.model(
  "MembershipAllActivity",
  membershipAllActivitySchema
);

module.exports = MembershipAllActivity;
