const { Router } = require("express");
const {
  deleteAllHelpCenter,
  deleteHelpCenter,
  getAllHelpCenter,
  updateHelpCenter,
  getHelpCenter,
  addHelpCenter,
} = require("../controllers/help_center_controller.js");
const helpCenterRouter = Router();

helpCenterRouter
  .get("/delete/:helpcenterId", deleteHelpCenter)
  .get("/get/:helpcenterId", getHelpCenter)
  .get("/delete_all", deleteAllHelpCenter)
  .post("/update", updateHelpCenter)
  .get("/get_all", getAllHelpCenter)
  .post("/add", addHelpCenter);

module.exports = helpCenterRouter;
