const { Router } = require("express");
const {
  cancelMembership,
  addMembershipHistory,
  getMembershipHistory,
  updateMembershipHistory,
  getMembershipAllActivity,
} = require("../controllers/membership_history_detail_controller.js");
const membershipHistory = Router();

membershipHistory
  .get("/get_membership_history/:membershipActivityId", getMembershipHistory)
  .get("/get_all_activity/:userId", getMembershipAllActivity)
  .post("/add_membership", addMembershipHistory)
  .post("/cancel_membership", cancelMembership)
  .post("/update", updateMembershipHistory);

module.exports = membershipHistory;
