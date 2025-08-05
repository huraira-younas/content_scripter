const mongoose = require("mongoose");

const membershipTimeSchema = new mongoose.Schema({
  adminId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
    unique: true,
  },
  timePeriod: [
    {
      time: {
        type: Number,
        required: true,
      },
      discount: {
        type: Number,
        default: 0,
      },
    },
  ],
});

const MembershipTime = mongoose.model("MembershipTime", membershipTimeSchema);
module.exports = MembershipTime;
