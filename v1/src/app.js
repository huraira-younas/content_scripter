const membershipHistory = require("./routes/membership_history_detail_router.js");
const membershipPlanRouter = require("./routes/membership_plan_router.js");
const membershipTimeRouter = require("./routes/membership_time_router.js");
const onBoardingRouter = require("./routes/on_boarding_router.js");
const helpCenterRouter = require("./routes/help_center_router.js");
const assistantRouter = require("./routes/assistant_router.js");
const historyRouter = require("./routes/history_router.js");
const messageRouter = require("./routes/message_router.js");
const checkToken = require("./middlewares/check_token.js");
const promptRouter = require("./routes/prompt_router.js");
const trendsRouter = require("./routes/trends_router.js");
const authRouter = require("./routes/auth_router.js");
const express = require("express");
const cors = require("cors");

const app = express();
app.use(
  cors({
    origin: process.env.CORS_ORIGIN,
    credentials: true,
  })
);

app.use(express.json());
app.use("/v1/auth/api", checkToken, authRouter);
app.use("/v1/prompt/api", checkToken, promptRouter);
app.use("/v1/trends/api", checkToken, trendsRouter);
app.use("/v1/message/api", checkToken, messageRouter);
app.use("/v1/history/api", checkToken, historyRouter);
app.use("/v1/assistant/api", checkToken, assistantRouter);
app.use("/v1/on_boarding/api", checkToken, onBoardingRouter);
app.use("/v1/help_center/api", checkToken, helpCenterRouter);
app.use("/v1/membership_plan/api", checkToken, membershipPlanRouter);
app.use("/v1/membership_time/api", checkToken, membershipTimeRouter);
app.use("/v1/membership_history/api", checkToken, membershipHistory);
app.get("/v1/", (_, res) => res.json("Welcome to Content-Scripter"));

module.exports = app;
