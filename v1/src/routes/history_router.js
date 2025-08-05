const { Router } = require("express");
const {
  deleteHistory,
  updateHistory,
  addSharedUser,
  getHistory,
  addHistory,
} = require("../controllers/history_controller.js");
const historyRouter = Router();

historyRouter
  .post("/add_user", addSharedUser)
  .get("/get/:userId", getHistory)
  .post("/delete", deleteHistory)
  .post("/update", updateHistory)
  .post("/add", addHistory);

module.exports = historyRouter;
