const mongoose = require("mongoose");

const helpCenterSchema = new mongoose.Schema({
  adminId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  privacyPolicy: {
    type: String,
    required: true,
  },
  termAndServices: {
    type: String,
    required: true,
  },
  contactUs: [
    {
      title: String,
      icon: String,
      text: String,
    },
  ],
  faq: [
    {
      catName: String,
      items: [
        {
          title: String,
          text: String,
        },
      ],
    },
  ],
});

const HelpCenter = mongoose.model("HelpCenter", helpCenterSchema);
module.exports = HelpCenter;
