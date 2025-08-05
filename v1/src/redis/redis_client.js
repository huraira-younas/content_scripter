const Redis = require("ioredis");

const redis = new Redis({
  password: process.env.REDIS_PASSWORD,
  port: process.env.REDIS_PORT,
  host: process.env.REDIS_HOST,
  maxRetriesPerRequest: null,
});

redis.on("connect", async () => {
  console.log("Connected to Redis server");
});

redis.on("error", (err) => {
  console.error(`Error connecting to Redis: ${err}`);
});

module.exports = redis;
