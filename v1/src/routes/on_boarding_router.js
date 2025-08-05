const { Router } = require("express");
const {
  getPage,
  addPage,
  deletePage,
  updatePage,
  getAllPages,
  deleteAllPages,
} = require("../controllers/on_boarding_controller.js");
const onBoardingRouter = Router();

onBoardingRouter
  .get("/delete_all", deleteAllPages)
  .get("/delete/:pageId", deletePage)
  .get("/get/:pageId", getPage)
  .get("/get_all", getAllPages)
  .post("/update", updatePage)
  .post("/add", addPage);

module.exports = onBoardingRouter;
