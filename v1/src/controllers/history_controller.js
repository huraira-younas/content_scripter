const History = require("../models/history_model.js");
const Message = require("../models/message_model.js");
const User = require("../models/user_model.js");
const moment = require("moment");

const addHistory = async (req, res) => {
  try {
    const { _id, ...data } = req.body;
    const created = moment().utc().format();

    const [user, history] = await Promise.all([
      User.findById(data.userId).select("-password").lean(),
      History.create({
        ...data,
        created,
        shared: [data.userId],
      }),
    ]);

    if (!history || !user) {
      return res.status(400).json({ error: "Failed to create history" });
    }

    let newHistory = history.toObject();
    newHistory.shared = [user];

    res.json(newHistory);
  } catch (err) {
    console.log("Error Adding History", err.message);
    res.status(500).json({ error: err.message });
  }
};

const updateHistory = async (req, res) => {
  try {
    const { _id, ...updateData } = req.body;

    const history = await History.findByIdAndUpdate(_id, updateData, {
      runValidators: true,
      new: true,
    }).populate({ path: "shared", select: "-password" });

    if (!history) {
      return res.status(400).json({ error: "Failed to update history" });
    }

    res.json(history);
  } catch (err) {
    console.log("Error Adding History", err.message);
    res.status(500).json({ error: err.message });
  }
};

const getHistory = async (req, res) => {
  try {
    const userId = req.params.userId;
    const [histories, sharedHistories] = await Promise.all([
      History.find({ userId })
        .sort({ created: -1 })
        .populate({ path: "shared", select: "-password" }),

      History.find({
        shared: userId,
        userId: { $ne: userId },
      })
        .sort({ created: -1 })
        .populate({ path: "shared", select: "-password" }),
    ]);

    console.groupCollapsed("Get History");
    console.table({
      user: userId,
      shared: sharedHistories?.length + " item",
      history: histories?.length + " item",
    });
    console.groupEnd();

    res.json({ history: histories, shared: sharedHistories });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const addSharedUser = async (req, res) => {
  try {
    const { _id, email } = req.body;

    const user = await User.findOne({ email }).lean();
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const historyUpdate = await History.findByIdAndUpdate(
      _id,
      { $addToSet: { shared: user._id } },
      { runValidators: true, new: true }
    ).populate({ path: "shared", select: "-password" });

    if (!historyUpdate) {
      return res.status(400).json({ error: "Failed to update history" });
    }

    res.json(historyUpdate);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const deleteHistory = async (req, res) => {
  try {
    const { sessionIds } = req.body;

    if (!Array.isArray(sessionIds) || sessionIds.length === 0) {
      return res.status(400).json({ error: "No session IDs provided" });
    }

    const historyRes = await History.deleteMany({
      sessionId: { $in: sessionIds },
    });
    const messageRes = await Message.deleteMany({
      sessionId: { $in: sessionIds },
    });

    console.groupCollapsed("Delete History");
    console.table({
      history: historyRes.deletedCount,
      messages: messageRes.deletedCount,
    });
    console.groupEnd();

    res.json("Histories and associated messages deleted successfully");
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = {
  addSharedUser,
  deleteHistory,
  updateHistory,
  addHistory,
  getHistory,
};
