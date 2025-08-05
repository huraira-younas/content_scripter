const { Router } = require("express");
const {
  deleteAllPromptModels,
  getAllPromptModels,
  deletePromptModel,
  updatePromptModel,
  getPromptModel,
  addPromptModel,
} = require("../controllers/prompt_controller.js");
const promptRouter = Router();

promptRouter
  .get("/delete/:promptModelId", deletePromptModel)
  .get("/get/:promptModelId", getPromptModel)
  .get("/delete_all", deleteAllPromptModels)
  .get("/get_all", getAllPromptModels)
  .post("/update", updatePromptModel)
  .post("/add", addPromptModel);

module.exports = promptRouter;
