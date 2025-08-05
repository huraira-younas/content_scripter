const {
  setToRedis,
  getFromRedis,
  deleteFromRedis,
  getListFromRedis,
  setListFromRedis,
  deleteFromRedisByPattern,
} = require("../redis/redis_methods.js");
const Assistant = require("../models/assistant_model.js");
const expire = require("../redis/redis_expire.js");
const User = require("../models/user_model.js");

const addAssistant = async (req, res) => {
  try {
    const { email } = req.body;
    const key = `user:${email}`;
    const redisUser = await getFromRedis(key);

    const user = redisUser || (await User.findOne({ email }));
    if (!user || user.isBan) {
      const message = !user
        ? "User not found"
        : "You are banned from adding assistant";
      return res.status(400).json({ error: message });
    }

    const adminId = user._id;
    const newAssistant = await Assistant.create({
      ...req.body,
      adminId,
    });

    const assistantKey = `assistant:${newAssistant._id}`;

    await Promise.all([
      setToRedis(assistantKey, newAssistant, expire.assistant),
      setToRedis(key, redisUser, expire.user),
    ]);

    res.json(newAssistant);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getAssistant = async (req, res) => {
  try {
    const { assistantId } = req.params;
    const key = `assistant:${assistantId}`;
    const redisAssistant = await getFromRedis(key);
    const assistant = redisAssistant || (await Assistant.findById(assistantId));
    if (!assistant) {
      return res.status(404).json({ error: "Assistant not found" });
    }
    await setToRedis(key, assistant, expire.assistant);

    res.json(assistant);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const updateAssistant = async (req, res) => {
  try {
    const { assistantId, email, ...update } = req.body;

    const key = `user:${email}`;
    const redisUser = await getFromRedis(key);

    const user = redisUser || (await User.findOne({ email }));
    if (!user || user.status !== "admin" || user.isBan) {
      return res.status(400).json({ error: "Only admin can do CRUD OP." });
    }

    const assistant = await Assistant.findByIdAndUpdate(
      assistantId,
      { ...update },
      { new: true }
    );

    if (!assistant) {
      return res.status(404).json({ error: "Assistant not found" });
    }

    const assistantKey = `assistant:${assistantId}`;

    await Promise.all([
      setToRedis(assistantKey, assistant, expire.assistant),
      setToRedis(key, user, expire.user),
    ]);

    res.json(assistant);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const deleteAssistant = async (req, res) => {
  try {
    const { assistantId } = req.params;
    const assistantKey = `assistant:${assistantId}`;
    const deleteOB = await Assistant.findByIdAndDelete(assistantId);
    if (!deleteOB) {
      return res.status(404).json({ error: "Assistant not found" });
    }
    await deleteFromRedis(assistantKey);
    res.json({ message: "Assistant deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getAllAssistants = async (_, res) => {
  try {
    const precached = await getListFromRedis("assistant");
    const total = await Assistant.countDocuments();

    if (precached) {
      console.log("Precached Assistant");
    }

    let assistants = precached;
    if (precached?.length !== total) {
      console.log("Assistants From Db");
      assistants = await Assistant.find();
      await deleteFromRedisByPattern("assistant");
      await setListFromRedis("assistant", assistants, expire.assistant);
    }

    res.json(assistants);
  } catch (err) {
    res.status(500).json({ error: err.medossage });
  }
};

const deleteAllAssistants = async (_, res) => {
  try {
    await Assistant.deleteMany();
    await deleteFromRedisByPattern("assistant");
    res.json("Deleted Successfully");
  } catch (err) {
    res.status(500).json({ error: err.medossage });
  }
};

module.exports = {
  deleteAllAssistants,
  getAllAssistants,
  updateAssistant,
  deleteAssistant,
  getAssistant,
  addAssistant,
};
