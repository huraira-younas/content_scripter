const redis = require("./redis_client.js");

const parseJson = (data) => (data ? JSON.parse(data) : null);
const setToRedis = async (key, value, expire = 1) => {
  try {
    console.log("Setting to redis: ", key);
    const pipeline = redis.pipeline();
    pipeline.hset(key, "data", JSON.stringify(value));
    if (expire > 0) {
      pipeline.expire(key, expire * 60);
    }
    const [res] = await pipeline.exec();
    if (res) {
      console.log(`Data set successfully ${res}`);
    }
  } catch (err) {
    console.error(`Redis Error: ${err}`);
  }
};

const setSetToRedis = async (key, value) => {
  try {
    console.log("Setting to redis: ", key);
    await redis.sadd(key, value);
  } catch (err) {
    console.error(`Redis Error: ${err}`);
  }
};

const isMemberOfSet = async (key, value) => {
  redis.sismember(key, value, (err, reply) => {
    if (err) {
      console.error("Error checking value in set:", err);
      return false;
    }
    if (reply === 1) {
      console.log(`${valueToCheck} exists in the set ${key}`);
      return true;
    } else {
      console.log(`${valueToCheck} does not exist in the set ${key}`);
      return false;
    }
  });
};

const getSetFromRedis = async (key) => {
  try {
    console.log("Getting from redis: ", key);
    return await redis.smembers(key);
  } catch (err) {
    console.error(`Redis Error: ${err}`);
  }
};

const removeSetFromRedis = async (key, value) => {
  try {
    console.log("Removing from redis: ", key);
    await redis.srem(key, value);
  } catch (err) {
    console.error(`Redis Error: ${err}`);
  }
};

const getFromRedis = async (key) => {
  try {
    const data = await redis.hget(key, "data");
    return parseJson(data);
  } catch (err) {
    console.error(`Error getting data: ${err.message}`);
    return null;
  }
};

const getTimeToLive = async (key) => {
  console.log("Getting time to live:", key);
  return await redis.ttl(key);
};

const getSpecificList = async (pattern, keys) => {
  try {
    const pipeline = redis.pipeline();
    keys.forEach((key) => pipeline.hget(`${pattern}:${key}`, "data"));
    const results = await pipeline.exec();
    const data = results.map(([err, res]) => parseJson(res));
    return data.length ? data : null;
  } catch (err) {
    console.error(`Error getting data: ${err.message}`);
    return null;
  }
};

const getListFromRedis = async (keyPattern) => {
  try {
    const keys = await redis.keys(`*${keyPattern}*`);
    if (!keys.length) return null;

    const pipeline = redis.pipeline();
    keys.forEach((key) => pipeline.hget(key, "data"));
    const results = await pipeline.exec();
    const data = results.map(([err, res]) => parseJson(res));

    return data.length ? data : null;
  } catch (err) {
    console.error(`Error getting data: ${err.message}`);
    return null;
  }
};

const setListFromRedis = async (field, values, expire = 60) => {
  if (values?.length === 0) return;

  try {
    console.log("Setting list to redis: ", field);
    const pipeline = redis.pipeline();
    values.forEach((value) => {
      const key = `${field}:${value._id}`;
      pipeline
        .hset(key, "data", JSON.stringify(value))
        .expire(key, expire * 60);
    });

    await pipeline.exec();
    console.log(`Data set successfully for ${values.length} items`);
  } catch (err) {
    console.error(`Error setting data: ${err.message}`);
  }
};

const deleteFromRedis = async (key) => {
  try {
    const deleted = await redis.hdel(key, "data");
    if (deleted) {
      console.log(`Data deleted successfully`);
    } else {
      console.log(`No data found for ${key} to delete`);
    }
  } catch (err) {
    console.error(`Error deleting data: ${err.message}`);
  }
};

const deleteFromRedisByPattern = async (keyPattern) => {
  try {
    const keys = await redis.keys(`*${keyPattern}*`);
    if (!keys.length) {
      console.log(`No keys found matching pattern: ${keyPattern}`);
      return;
    }
    const pipeline = redis.pipeline();
    keys.forEach((key) => pipeline.del(key));
    await pipeline.exec();

    console.log(`Deleted keys matching pattern: ${keyPattern}`);
  } catch (err) {
    console.error(`Error deleting keys by pattern: ${err.message}`);
    throw err;
  }
};

module.exports = {
  deleteFromRedisByPattern,
  removeSetFromRedis,
  getListFromRedis,
  setListFromRedis,
  getSetFromRedis,
  getSpecificList,
  deleteFromRedis,
  getTimeToLive,
  isMemberOfSet,
  setSetToRedis,
  getFromRedis,
  setToRedis,
};
