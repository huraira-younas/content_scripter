const { Router } = require("express");
const {
  addMembershipTime,
  getMembershipTime,
  updateMembershipTime,
  deleteMembershipTime,
  getAllMembershipsTime,
  deleteAllMembershipsTime,
} = require("../controllers/membership_time_controller.js");
const membershipTimeRouter = Router();

membershipTimeRouter
  .get("/delete/:MembershipTimeId", deleteMembershipTime)
  .get("/get/:MembershipTimeId", getMembershipTime)
  .get("/delete_all", deleteAllMembershipsTime)
  .get("/get_all", getAllMembershipsTime)
  .post("/update", updateMembershipTime)
  .post("/add", addMembershipTime);

module.exports = membershipTimeRouter;
