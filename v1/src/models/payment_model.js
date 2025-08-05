const mongoose = require("mongoose");

const paymentSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    expireAt: {
      type: Date,
      required: true,
    },
  },
  { timestamps: true }
);

const Payment = mongoose.model("Payment", paymentSchema);
module.exports = Payment;
