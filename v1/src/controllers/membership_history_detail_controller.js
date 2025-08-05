const {
  setToRedis,
  getFromRedis,
  getListFromRedis,
} = require("../redis/redis_methods.js");
const MembershipAllActivity = require("../models/membership_all_activity_model.js");
const MembershipHistory = require("../models/membership_history_model.js");
const MembershipPlan = require("../models/membership_plan_model.js");
const getFeature = require("../methods/get_features.js");
const Payment = require("../models/payment_model.js");
const expire = require("../redis/redis_expire.js");
const User = require("../models/user_model.js");
const mongoose = require("mongoose");

const daysToDate = (days) => {
  const date = new Date();
  date.setDate(date.getDate() + days);
  date.setHours(0, 0, 0, 0);
  return date;
};

const addMembershipHistory = async (req, res) => {
  const session = await mongoose.startSession();
  try {
    session.startTransaction();
    const {
      userId,
      period,
      planType,
      taxAndFees,
      paymentMode,
      transactionId,
      membershipPlanId,
    } = req.body;
    const membershipKey = `membership:${membershipPlanId}`;

    const redisMembership = await getFromRedis(membershipKey);

    const membership =
      redisMembership || (await MembershipPlan.findById(membershipPlanId));

    if (!membership) {
      return res.status(404).json({ error: "Membership Plan not found" });
    }

    await Payment.findOneAndUpdate(
      { userId },
      { expireAt: daysToDate(period) },
      { upsert: true },
      { session }
    );

    const user = await User.findByIdAndUpdate(
      userId,
      { membershipId: membership._id },
      { new: true, session }
    );

    const newMembershipActivity = (
      await MembershipAllActivity.create(
        [
          {
            userId,
            planTitle: membership.title,
            totalAmount: period * membership.price + taxAndFees,
            planType,
          },
        ],
        { session }
      )
    )[0];

    await MembershipHistory.create(
      [
        {
          membershipActivityId: newMembershipActivity._id,
          totalAmount: period * membership.price + taxAndFees,
          planDetail: period,
          name: user.name,
          transactionId,
          paymentMode,
          taxAndFees,
        },
      ],
      { session }
    );
    console.log("current Date: ", new Date());
    const userKey = `user:${user.email}`;
    const newObj = user.toObject();
    delete newObj.password;

    await getFeature({
      membershipId: user.membershipId,
      userId: user._id,
      forceReset: true,
    });
    await Promise.all([
      setToRedis(membershipKey, membership, expire.glmpse),
      setToRedis(userKey, user, expire.user),
    ]);

    await session.commitTransaction();
    res.json("Payment successful");
  } catch (err) {
    console.log(err.message);
    await session.abortTransaction();
    res.status(500).json({ error: err.message });
  } finally {
    await session.endSession();
  }
};

const getMembershipHistory = async (req, res) => {
  try {
    const { membershipActivityId } = req.params;
    const membershipHistory = await MembershipHistory.findOne({
      membershipActivityId,
    });
    if (!membershipHistory) {
      return res.status(404).json({ error: "Membership History not found" });
    }

    res.json(membershipHistory);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getMembershipAllActivity = async (req, res) => {
  try {
    const { userId } = req.params;
    const membershipActivity = await MembershipAllActivity.find({ userId });
    if (!membershipActivity) {
      return res.status(404).json({ error: "Membership History not found" });
    }

    res.json(membershipActivity);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const updateMembershipHistory = async (req, res) => {
  try {
    const { membershipHistoryId } = req.body;

    const membershipHistory = await MembershipHistory.findByIdAndUpdate(
      membershipHistoryId,
      req.body,
      { new: true }
    );

    if (!membershipHistory) {
      return res.status(404).json({ error: "Membership History not found" });
    }

    await MembershipAllActivity.findOneAndUpdate(
      membershipHistory._id,
      req.body
    );

    res.json("History updated successfully");
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

//! ----------- cancel membership plan -------------

const cancelMembership = async (req, res) => {
  const session = await mongoose.startSession();
  try {
    session.startTransaction();
    const { userId } = req.body;
    let redisGlmpse = await getListFromRedis("glmpse");

    const allGlmpse = redisGlmpse || (await MembershipPlan.find());
    const filtered = allGlmpse?.filter((mem) => mem.price === 0);
    if (filtered.length === 0) {
      return res.status(400).json({ error: "Couln't find free membership" });
    }

    const freeMembership = filtered[0];
    const user = await User.findByIdAndUpdate(
      userId,
      { membershipId: freeMembership._id },
      { new: true, session }
    );

    await Payment.findOneAndDelete({ userId }, { session });

    const userKey = `user:${user.email}`;

    const newObj = user.toObject();
    delete newObj.password;

    console.log("Cancelled Membership");

    await getFeature({
      membershipId: user.membershipId,
      userId: user._id,
      forceReset: true,
    });
    await setToRedis(userKey, user, expire.user);

    await session.commitTransaction();
    res.json("Membership cancelled successfully");
  } catch (err) {
    await session.abortTransaction();
    res.status(500).json({ error: err.message });
  } finally {
    await session.endSession();
  }
};

module.exports = {
  getMembershipAllActivity,
  updateMembershipHistory,
  addMembershipHistory,
  getMembershipHistory,
  cancelMembership,
};
