const mongoose = require("mongoose");

const emailValidator = {
  validator: (value) => {
    const re =
      /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z]{2,})+$/;
    return re.test(value);
  },
  message: "Please enter a valid email",
};

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  profileUrl: {
    type: String,
    default: "",
  },
  username: {
    type: String,
    unique: true,
    required: true,
    trim: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    validate: emailValidator,
  },
  phone: {
    code: {
      type: String,
      trim: true,
    },
    phoneCode: {
      type: String,
      trim: true,
    },
    country: {
      type: String,
      trim: true,
    },
    number: {
      type: String,
      trim: true,
    },
  },
  password: {
    type: String,
    required: true,
  },
  status: {
    type: String,
    enum: {
      values: ["user", "admin"],
      message: "{VALUE} is not supported",
    },
    default: "user",
  },
  membershipId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "MembershipPlan",
  },
});

const User = mongoose.model("User", userSchema);
module.exports = User;
