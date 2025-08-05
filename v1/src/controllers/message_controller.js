const { setToRedis } = require("../redis/redis_methods.js");
const getFeature = require("../methods/get_features.js");
const Message = require("../models/message_model.js");
const moment = require("moment");

const addMessage = async (req, res) => {
  try {
    const { userId, membershipId, role, imageUrl } = req.body;
    const featureKey = `feature:${userId}:data`;
    const isModel = role === "model";

    if (!isModel) {
      let feature = await getFeature({ userId, membershipId });
      const { promptsLimit, fileInput } = feature;

      if (!imageUrl && promptsLimit.current >= promptsLimit.max) {
        return res.status(400).json({ error: "Prompt limit exceeded" });
      }

      if (imageUrl && fileInput.image.current >= fileInput.image.max) {
        return res.status(400).json({ error: "File input limit exceeded" });
      }

      imageUrl ? fileInput.image.current++ : promptsLimit.current++;
      await setToRedis(featureKey, feature, 0);
    }

    const time = moment().utc().format();
    const message = await Message.create({ ...req.body, time });

    if (!message) {
      return res.status(400).json({ error: "Failed to create message" });
    }

    res.json(message);
  } catch (err) {
    console.error("Error Adding Message:", err.message);
    res.status(500).json({ error: err.message });
  }
};

const getAllMessages = async (req, res) => {
  try {
    const sessionId = req.params.sessionId;
    const messages = await Message.find({ sessionId }).sort({ time: -1 });

    console.groupCollapsed("Messages");
    console.table({
      sessionId: sessionId,
      messageCount: messages.length,
    });
    console.groupEnd();

    res.json(messages);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = { addMessage, getAllMessages };
