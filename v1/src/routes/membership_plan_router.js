const { Router } = require("express");
const {
  addMembershipPlan,
  getMembershipPlan,
  updateMembershipPlan,
  deleteMembershipPlan,
  getAllMembershipPlans,
  deleteAllMembershipPlans,
} = require("../controllers/membership_plan_controller.js");
const MembershipPlanRouter = Router();

MembershipPlanRouter.get("/delete/:membershipPlanId", deleteMembershipPlan)
  .get("/get/:membershipPlanId", getMembershipPlan)
  .get("/delete_all/", deleteAllMembershipPlans)
  .get("/get_all", getAllMembershipPlans)
  .post("/update", updateMembershipPlan)
  .post("/add", addMembershipPlan);

module.exports = MembershipPlanRouter;
