const { Router } = require("express");
const {
  sendOtp,
  getUser,
  loginUser,
  verifyOtp,
  updateUser,
  signupUser,
  getAllUsers,
  updatePassword,
  getUserFeature,
} = require("../controllers/auth_controller.js");
const authRouter = Router();

authRouter
  .post("/login", loginUser)
  .post("/signup", signupUser)
  .post("/send_otp", sendOtp)
  .post("/verify_otp", verifyOtp)
  .post("/update_user", updateUser)
  .get("/get_user/:email", getUser)
  .post("/get_feature", getUserFeature)
  .post("/update_password", updatePassword)
  .get("/get_all_users/users", getAllUsers);

module.exports = authRouter;
