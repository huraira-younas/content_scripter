const {
  setToRedis,
  getFromRedis,
  deleteFromRedis,
  deleteFromRedisByPattern,
} = require("../redis/redis_methods.js");
const PromptModel = require("../models/prompt_model.js");
const expire = require("../redis/redis_expire.js");
const User = require("../models/user_model.js");

const addPromptModel = async (req, res) => {
  try {
    const { email } = req.body;
    const key = `user:${email}`;
    const redisUser = await getFromRedis(key);

    const user = redisUser || (await User.findOne({ email }));
    if (!user || user.status !== "admin" || user.isBan) {
      return res.status(400).json({ error: "Only admin can do CRUD OP." });
    }

    await Promise.all([
      PromptModel.deleteMany(),
      deleteFromRedisByPattern("promptModel"),
    ]);

    const newPromptModel = await PromptModel.create({
      ...req.body,
      adminId: user._id,
    });

    const promptModelKey = "promptModel:adminPrompts";
    await Promise.all([
      setToRedis(promptModelKey, newPromptModel, expire.prompt),
      setToRedis(key, redisUser, expire.user),
    ]);

    res.json(newPromptModel);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getPromptModel = async (req, res) => {
  try {
    const { promptModelId } = req.params;
    const key = "promptModel:adminPrompts";
    const redisPromptModel = await getFromRedis(key);
    const promptModel =
      redisPromptModel || (await PromptModel.findById(promptModelId));

    if (!promptModel) {
      return res.status(404).json({ error: "PromptModel not found" });
    }
    await setToRedis(key, promptModel, expire.prompt);

    res.json(promptModel);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const updatePromptModel = async (req, res) => {
  try {
    const { promptModelId, email } = req.body;

    const key = `user:${email}`;
    const redisUser = await getFromRedis(key);

    const user = redisUser || (await User.findOne({ email }));
    if (!user || user.status !== "admin" || user.isBan) {
      return res.status(400).json({ error: "Only admin can do CRUD OP." });
    }

    const promptModel = await PromptModel.findByIdAndUpdate(
      promptModelId,
      req.body,
      { new: true }
    );

    if (!promptModel) {
      return res.status(404).json({ error: "PromptModel not found" });
    }

    const promptModelkey = "promptModel:adminPrompts";

    await Promise.all([
      setToRedis(promptModelkey, promptModel, expire.promptModel),
      setToRedis(key, user, expire.user),
    ]);

    res.json(promptModel);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const deletePromptModel = async (req, res) => {
  try {
    const { promptModelId } = req.params;
    const promptModelkey = "promptModel:adminPrompts";
    const deleteOB = await PromptModel.findByIdAndDelete(promptModelId);
    if (!deleteOB) {
      return res.status(404).json({ error: "PromptModel not found" });
    }

    await deleteFromRedis(promptModelkey);
    res.json({ message: "PromptModel deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getAllPromptModels = async (_, res) => {
  try {
    const precached = await getFromRedis("promptModel:adminPrompts");
    if (precached) {
      console.log("Precached PromptModel");
      return res.json(precached);
    }

    const promptModel = await PromptModel.findOne();
    if (!promptModel) {
      return res.status(404).json({ error: "PromptModel not found" });
    }

    const PromptModelkey = "promptModel:adminPrompts";
    await setToRedis(PromptModelkey, promptModel, expire.prompt);

    res.json(promptModel);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const deleteAllPromptModels = async (_, res) => {
  try {
    await PromptModel.deleteMany();
    await deleteFromRedisByPattern("PromptModel");
    res.json("Deleted Successfully");
  } catch (err) {
    res.status(500).json({ error: err.medossage });
  }
};

module.exports = {
  deleteAllPromptModels,
  getAllPromptModels,
  updatePromptModel,
  deletePromptModel,
  addPromptModel,
  getPromptModel,
};
