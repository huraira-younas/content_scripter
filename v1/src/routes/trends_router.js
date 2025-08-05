const googleTrends = require("google-trends-api");
const { Router } = require("express");
const trendsRouter = Router();

trendsRouter.post("/fetch_interest", async (req, res) => {
  try {
    const { keywords } = req.body;

    if (!keywords || !Array.isArray(keywords)) {
      return res.status(404).json({ error: "Invalid keywords" });
    }

    const response = await googleTrends.interestOverTime({
      keyword: keywords[0],
    });
    try {
      const parsed = JSON.parse(response);
      res.json(parsed);
    } catch (e) {
      res.json(response);
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

trendsRouter.post("/fetch_trends", async (req, res) => {
  try {
    const { category } = req.body;
    const response = await googleTrends.realTimeTrends({ geo: "US", category });
    try {
      const parsed = JSON.parse(response);
      const trending = parsed.storySummaries.trendingStories;
      res.json(trending);
    } catch (e) {
      res.json(response);
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = trendsRouter;
