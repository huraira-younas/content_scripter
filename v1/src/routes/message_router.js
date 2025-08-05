const {
  addMessage,
  getAllMessages,
} = require("../controllers/message_controller.js");
const { Router } = require("express");
const messageRouter = Router();

messageRouter.get("/get/:sessionId", getAllMessages).post("/add", addMessage);
module.exports = messageRouter;
