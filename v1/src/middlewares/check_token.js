const checkToken = (req, res, next) => {
  try {
    const token = req.headers.authorization;

    if (!token) {
      return res.status(400).json({ error: "Required authorization token" });
    }

    if (token === process.env.ACCESS_TOKEN) {
      return next();
    }

    res.status(400).json({ error: "Authorization failed, invalid token" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = checkToken;
