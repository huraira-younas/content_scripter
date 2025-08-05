const {
  setToRedis,
  getFromRedis,
  deleteFromRedis,
  getListFromRedis,
} = require("../redis/redis_methods.js");
const User = require("../models/user_model.js");
const HelpCenter = require("../models/help_center_model.js");
const expire = require("../redis/redis_expire.js");

const addHelpCenter = async (req, res) => {
  try {
    const { email } = req.body;
    const key = `user:${email}`;
    const redisUser = await getFromRedis(key);

    const user = redisUser || (await User.findOne({ email }));
    if (!user || user.status !== "admin" || user.isBan) {
      return res.status(400).json({ error: "Only admin can do CRUD OP." });
    }

    const precached = await getListFromRedis("helpCenter");

    let helpCenter =
      (precached && precached[0]) || (await HelpCenter.findOne());
    if (helpCenter) {
      return res.status(400).json({ error: "You can add only once." });
    }

    helpCenter = await HelpCenter.create({
      ...req.body,
      adminId: user._id,
    });

    if (!helpCenter) {
      return res.status(400).json({ error: "Couldn't create help center." });
    }

    const helpCenterKey = `helpCenter:${helpCenter._id}`;

    await Promise.all([
      setToRedis(helpCenterKey, helpCenter, expire.helpCenter),
      setToRedis(key, redisUser, expire.user),
    ]);

    res.json(helpCenter);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getHelpCenter = async (req, res) => {
  try {
    const { helpcenterId } = req.params;
    const helpCenterKey = `helpCenter:${helpcenterId}`;

    const redisHelpCenter = await getFromRedis(helpCenterKey);
    const helpCenter = redisHelpCenter || (await HelpCenter.findOne());
    if (!helpCenter) {
      return res.status(404).json({ error: "Help Center not found" });
    }
    await setToRedis(helpCenterKey, helpCenter, expire.helpCenter);

    res.json(helpCenter);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const updateHelpCenter = async (req, res) => {
  try {
    const { email } = req.body;

    const key = `user:${email}`;
    const redisUser = await getFromRedis(key);

    const user = redisUser || (await User.findOne({ email }));
    if (!user || user.status !== "admin" || user.isBan) {
      return res.status(400).json({ error: "Only admin can do CRUD OP." });
    }

    const helpCenter = await HelpCenter.findOneAndUpdate({}, req.body, {
      upsert: true,
      new: true,
    });

    if (!helpCenter) {
      return res.status(404).json({ error: "Help Center not found" });
    }

    const helpCenterKey = `helpCenter:${helpCenter._id}`;

    await Promise.all([
      setToRedis(helpCenterKey, helpCenter, expire.helpCenter),
      setToRedis(key, user, expire.user),
    ]);

    res.json(helpCenter);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const deleteHelpCenter = async (req, res) => {
  try {
    const { helpcenterId } = req.params;

    const deleteOB = await HelpCenter.findByIdAndDelete(helpcenterId);
    if (!deleteOB) {
      return res.status(404).json({ error: "Help Center not found" });
    }
    const helpCenterKey = `helpCenter:${helpcenterId}`;
    await deleteFromRedis(helpCenterKey);
    res.json({ message: "Help Center deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getAllHelpCenter = async (_, res) => {
  try {
    const precached = await getListFromRedis("helpCenter");
    if (precached && precached.length > 0) {
      console.log("Precached Help Center");
      return res.json(precached[0]);
    }

    const helpCenter = await HelpCenter.findOne();
    if (!helpCenter) {
      return res.status(404).json({ error: "Help Center not found" });
    }

    const helpCenterKey = `helpCenter:${helpCenter._id}`;

    await setToRedis(helpCenterKey, helpCenter, expire.helpCenter);

    res.json(helpCenter);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const deleteAllHelpCenter = async (_, res) => {
  try {
    await Promise.all([
      HelpCenter.deleteMany(),
      deleteFromRedisByPattern("helpCenter"),
    ]);

    res.json("Deleted Successfully");
  } catch (err) {
    res.status(500).json({ error: err.medossage });
  }
};

module.exports = {
  deleteAllHelpCenter,
  getAllHelpCenter,
  updateHelpCenter,
  deleteHelpCenter,
  getHelpCenter,
  addHelpCenter,
};
