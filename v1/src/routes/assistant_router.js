const { Router } = require("express");
const {
  getAssistant,
  addAssistant,
  deleteAssistant,
  updateAssistant,
  getAllAssistants,
  deleteAllAssistants,
} = require("../controllers/assistant_controller.js");
const onBoardingRouter = Router();

onBoardingRouter
  .post("/add", addAssistant)
  .post("/update", updateAssistant)
  .get("/get_all", getAllAssistants)
  .get("/get/:assistantId", getAssistant)
  .get("/delete_all", deleteAllAssistants)
  .get("/delete/:assistantId", deleteAssistant);

module.exports = onBoardingRouter;
