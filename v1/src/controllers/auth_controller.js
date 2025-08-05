const {
  setListFromRedis,
  getListFromRedis,
  deleteFromRedis,
  getFromRedis,
  setToRedis,
} = require("../redis/redis_methods.js");
const { sendOtpEmail, generateOTP } = require("../methods/send_otp.js");
const MembershipPlan = require("../models/membership_plan_model.js");
const getFeature = require("../methods/get_features.js");
const expire = require("../redis/redis_expire.js");
const User = require("../models/user_model.js");
const Otp = require("../models/otp_model.js");
const bcryptjs = require("bcryptjs");

const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;
    const key = `user:${email}`;

    const redisUser = await getFromRedis(key);
    const user = redisUser || (await User.findOne({ email }, { __v: 0 }));

    if (!user) {
      return res.status(400).json({ error: "User not found" });
    }

    const authentic = await bcryptjs.compare(password, user.password);
    if (!authentic) {
      return res.status(400).json({ error: "Invalid password" });
    }

    const [_, feature] = await Promise.all([
      setToRedis(key, user, expire.user),
      getFeature({ userId: user._id, membershipId: user.membershipId }),
    ]);

    const currentUser = redisUser ? user : user.toObject();
    delete currentUser.password;

    res.json({ user: currentUser, feature });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const signupUser = async (req, res) => {
  try {
    const { email, password, otp, isGoogle } = req.body;
    const otpKey = `otp:${email}`;
    const key = `user:${email}`;

    const [userOtp, redisUser, memberships] = await Promise.all([
      getFromRedis(otpKey),
      getFromRedis(key),
      getListFromRedis("membership"),
    ]);

    if (!userOtp && !isGoogle) {
      return res
        .status(400)
        .json({ error: "OTP is expired, please generate a new OTP" });
    }

    if (!isGoogle && userOtp.code.toString() !== otp) {
      return res.status(400).json({ error: "Invalid OTP" });
    }

    let user = redisUser || (await User.findOne({ email }));
    if (user && !isGoogle) {
      return res.status(400).json({ error: "Email already in use" });
    }

    const allMemberships = memberships || (await MembershipPlan.find());
    const filtered = allMemberships?.filter((mem) => mem.price === 0);
    if (filtered.length === 0) {
      return res.status(400).json({ error: "Couln't find free membership" });
    }
    const freeMembership = filtered[0];

    let planFeature;
    if (!user) {
      const username = email.split("@")[0];
      const hashedPassword = await bcryptjs.hash(password, 8);
      user = await User.create({
        ...req.body,
        username,
        password: hashedPassword,
        membershipId: freeMembership._id,
      });

      planFeature = await getFeature({
        membershipId: freeMembership._id,
        userId: user._id,
      });

      if (!user) {
        return res.status(400).json({ error: "Failed to register user" });
      }
    } else {
      planFeature = await getFeature({
        membershipId: freeMembership._id,
        userId: user._id,
      });
    }

    await Promise.all([
      setListFromRedis("membership", allMemberships, expire.glmpse),
      setToRedis(key, user, expire.user),
      deleteFromRedis(userOtp),
    ]);

    const userWoP = redisUser || user.toObject();
    delete userWoP.password;

    res.json({ user: userWoP, feature: planFeature });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const sendOtp = async (req, res) => {
  try {
    const { email, method } = req.body;
    const otpKey = `otp:${email}`;
    const key = `user:${email}`;

    if (!email) {
      return res.status(400).json({ error: "Email is required" });
    }

    const promises = await Promise.all([
      getFromRedis(key),
      deleteFromRedis(otpKey),
    ]);
    const redisUser = promises[0];

    const existUser = redisUser || (await User.findOne({ email }));
    if (method === "reset") {
      if (!existUser) {
        return res.status(400).json({ error: "Email not found" });
      }
    } else {
      if (existUser) {
        return res.status(400).json({ error: "Email is already in use" });
      }
    }

    const code = generateOTP();
    const response = await sendOtpEmail(email, code);

    if (response.status !== 200) {
      return res.status(400).json({ error: `Failed to send OTP to ${email}` });
    }

    const otp = new Otp(email, code);
    await setToRedis(otpKey, otp, expire.otp);
    console.table(otp);

    res.json("OTP send successfully");
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const updateUser = async (req, res) => {
  try {
    const { email, newEmail, user } = req.body;
    const userEmail = newEmail || email;

    const updatedUser = await User.findOneAndUpdate(
      { email },
      { ...user, email: userEmail },
      { new: true }
    );

    if (!updatedUser) {
      return res.status(404).json({ error: "User not found" });
    }

    const key = `user:${userEmail}`;
    await deleteFromRedis(`user:${email}`);
    await setToRedis(key, updatedUser, expire.user);

    const userObj = updatedUser.toObject();
    delete userObj.password;

    res.json(userObj);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const updatePassword = async (req, res) => {
  try {
    const { email, password, oldPassword } = req.body;

    const key = `user:${email}`;
    if (oldPassword && oldPassword.length > 0) {
      const redisUser = await getFromRedis(key);
      const user = redisUser || (await User.findOne({ email }));

      if (!user) {
        return res.status(400).json({ error: "User not found" });
      }

      const authentic = await bcryptjs.compare(oldPassword, user.password);
      if (!authentic) {
        return res.status(400).json({ error: "Invalid Current Password" });
      }
    }

    const hashed = await bcryptjs.hash(password, 8);
    const updatedUser = await User.findOneAndUpdate(
      { email },
      { password: hashed },
      { new: true }
    );

    if (!updatedUser) {
      return res.status(404).json({ error: "User not found" });
    }

    await setToRedis(key, updatedUser, expire.user);
    res.json("Password updated successfully");
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getUser = async (req, res) => {
  try {
    const email = req.params.email;
    const key = `user:${email}`;
    const redisUser = await getFromRedis(key);
    const user = redisUser || (await User.findOne({ email }));

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const currentUser = redisUser ? user : user.toObject();
    delete currentUser.password;

    res.json(currentUser);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const verifyOtp = async (req, res) => {
  try {
    const { email, otp } = req.body;

    console.log(email, otp);
    const otpKey = `otp:${email}`;
    const userOtp = await getFromRedis(otpKey);
    console.log(userOtp);

    if (!userOtp) {
      return res
        .status(400)
        .json({ error: "OTP expired please request a new OTP" });
    }

    if (userOtp.code.toString() !== otp) {
      return res.status(400).json({ error: "Invalid OTP" });
    }

    await deleteFromRedis(otpKey);
    res.json("OTP verified");
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getUserFeature = async (req, res) => {
  try {
    const { email } = req.body;
    const key = `user:${email}`;

    const redisUser = await getFromRedis(key);
    const user = redisUser || (await User.findOne({ email }, { __v: 0 }));

    if (!user) {
      return res.status(400).json({ error: "User not found" });
    }

    const [_, feature] = await Promise.all([
      setToRedis(key, user, expire.user),
      getFeature({ userId: user._id, membershipId: user.membershipId }),
    ]);

    const currentUser = redisUser ? user : user.toObject();
    delete currentUser.password;

    res.json({ user: currentUser, feature });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getAllUsers = async (req, res) => {
  try {
    const { page = 1, limit = 20, search, country } = req.query;
    const query = {
      status: { $ne: "admin" },
    };

    const regex = new RegExp(search, "i");
    if (regex) {
      query.$or = [
        { name: regex },
        { email: regex },
        { username: regex },
        { "phone.number": regex },
      ];
    }

    if (country) {
      query["phone.country"] = country;
    }

    // query.status = "user";

    const countPromise = User.countDocuments(query);
    const usersPromise = User.find(query)
      .limit(parseInt(limit))
      .skip((parseInt(page) - 1) * parseInt(limit))
      .sort({ createdAt: -1 });

    const [totalUsers, users] = await Promise.all([countPromise, usersPromise]);
    const totalPages = Math.ceil(totalUsers / limit);

    res.json({
      users,
      totalPages,
      totalUsers,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = {
  updatePassword,
  getUserFeature,
  getAllUsers,
  updateUser,
  signupUser,
  loginUser,
  verifyOtp,
  getUser,
  sendOtp,
};
