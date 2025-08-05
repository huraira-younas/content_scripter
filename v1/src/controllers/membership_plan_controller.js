const {
  setToRedis,
  getFromRedis,
  deleteFromRedis,
  getListFromRedis,
  setListFromRedis,
  deleteFromRedisByPattern,
} = require("../redis/redis_methods.js");
const User = require("../models/user_model.js");
const MembershipPlan = require("../models/membership_plan_model.js");
const expire = require("../redis/redis_expire.js");

const addMembershipPlan = async (req, res) => {
  try {
    const { email } = req.body;
    const key = `user:${email}`;
    const redisUser = await getFromRedis(key);

    const user = redisUser || (await User.findOne({ email }));
    console.log(user);
    if (!user || user.status !== "admin" || user.isBan) {
      return res.status(400).json({ error: "Only admin can do CRUD OP." });
    }
    const newMembershipPlan = await MembershipPlan.create({
      ...req.body,
      adminId: user._id,
    });

    const membershipPlanKey = `membership:${newMembershipPlan._id}`;

    await Promise.all([
      setToRedis(membershipPlanKey, newMembershipPlan, expire.membership),
      setToRedis(key, redisUser, expire.user),
    ]);

    res.json(newMembershipPlan);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getMembershipPlan = async (req, res) => {
  try {
    const { membershipPlanId } = req.params;
    const key = `membership:${membershipPlanId}`;
    const redisMembershipPlan = await getFromRedis(key);
    const membershipPlan =
      redisMembershipPlan || (await MembershipPlan.findById(membershipPlanId));
    if (!membershipPlan) {
      return res.status(404).json({ error: "Membership Plan not found" });
    }
    await setToRedis(key, membershipPlan, expire.membership);

    res.json(membershipPlan);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const updateMembershipPlan = async (req, res) => {
  try {
    const { membershipPlanId, email } = req.body;

    const key = `user:${email}`;
    const redisUser = await getFromRedis(key);

    const user = redisUser || (await User.findOne({ email }));
    if (!user || user.status !== "admin" || user.isBan) {
      return res.status(400).json({ error: "Only admin can do CRUD OP." });
    }

    const membershipPlan = await MembershipPlan.findByIdAndUpdate(
      membershipPlanId,
      req.body,
      {
        new: true,
      }
    );

    if (!membershipPlan) {
      return res.status(404).json({ error: "Membership Plan not found" });
    }

    const membershipPlankey = `membership:${membershipPlanId}`;

    await Promise.all([
      setToRedis(membershipPlankey, membershipPlan, expire.membership),
      setToRedis(key, user, expire.user),
    ]);

    res.json(membershipPlan);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const deleteMembershipPlan = async (req, res) => {
  try {
    const { membershipPlanId } = req.params;

    const isUsing = await User.findOne({ membershipId: membershipPlanId });
    if (isUsing) {
      return res.status(400).json({
        error: "Deletion Failed. User has subscribed to this membership",
      });
    }

    const membershipPlankey = `membership:${membershipPlanId}`;
    const deleteOB = await MembershipPlan.findByIdAndDelete(membershipPlanId);
    if (!deleteOB) {
      return res.status(400).json({ error: "Membership Plans not found" });
    }
    await deleteFromRedis(membershipPlankey);
    res.json({ message: "Membership Plan deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getAllMembershipPlans = async (_, res) => {
  try {
    const precached = await getListFromRedis("membership");
    const total = await MembershipPlan.countDocuments();

    let membershipPlans = precached;
    if (precached?.length !== total) {
      console.log("Membership Plans From Db");
      membershipPlans = await MembershipPlan.find();
      await deleteFromRedisByPattern("membership");
      await setListFromRedis("membership", membershipPlans, expire.membership);
    }

    res.json(membershipPlans);
  } catch (err) {
    res.status(500).json({ error: err.medossage });
  }
};

const deleteAllMembershipPlans = async (_, res) => {
  try {
    await Promise.all([
      MembershipPlan.deleteMany(),
      deleteFromRedisByPattern("membership"),
    ]);
    res.json("Deleted Successfully");
  } catch (err) {
    res.status(500).json({ error: err.medossage });
  }
};

module.exports = {
  deleteAllMembershipPlans,
  getAllMembershipPlans,
  updateMembershipPlan,
  deleteMembershipPlan,
  addMembershipPlan,
  getMembershipPlan,
};
