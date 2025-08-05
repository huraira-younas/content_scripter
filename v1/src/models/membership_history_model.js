const mongoose = require("mongoose");

const membershipHistorySchema = new mongoose.Schema({
  membershipActivityId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "MembershipAllActivity",
    required: true,
  },
  planDetail: {
    type: Number,
    required: true,
  },
  totalAmount: {
    type: Number,
    required: true,
  },
  taxAndFees: {
    type: Number,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  paymentMode: {
    type: String,
    required: true,
  },
  transactionId: {
    type: String,
    required: true,
  },
});

const MembershipHistory = mongoose.model(
  "MembershipHistory",
  membershipHistorySchema
);

module.exports = MembershipHistory;
