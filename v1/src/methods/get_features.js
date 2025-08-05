const {
  setToRedis,
  getFromRedis,
  getListFromRedis,
  setListFromRedis,
} = require("../redis/redis_methods.js");
const MembershipPlan = require("../models/membership_plan_model.js");
const Feature = require("../models/features_model.js");
const expire = require("../redis/redis_expire.js");

const getFeature = async ({
  userId,
  membershipId,
  isUpdate = true,
  forceReset = false,
}) => {
  console.log("Calling Get Feature");
  console.log("userId", userId);
  console.log("membershipId", membershipId);
  console.log("Force Reset", forceReset);

  const featureDataKey = `feature:${userId}:data`;
  const featureTimeKey = `feature:${userId}:time`;
  const timestamp = Date.now();

  let [featureData, featureTime, memberships] = await Promise.all([
    getFromRedis(featureDataKey),
    getFromRedis(featureTimeKey),
    getListFromRedis("membership"),
  ]);

  const allMemberships = memberships || (await MembershipPlan.find());
  let curMembership = allMemberships?.filter(
    (e) => e._id.toString() === membershipId?.toString()
  );
  if (curMembership.length === 0) return;
  curMembership = curMembership[0];

  console.group("Feature Data");
  try {
    featureData = featureData || (await Feature.findOne({ userId }).lean());
    if (forceReset || !featureData || !featureTime) {
      console.log("Resetting feature data");
      if (!featureData) {
        featureData = (
          await Feature.create({
            userId,
            fileInput: {
              image: {
                max: curMembership.fileInput.image,
                current: 0,
              },
            },
            promptsLimit: {
              max: curMembership.promptsLimit.max,
              current: 0,
            },
            resetDuration: curMembership.resetDuration,
          })
        ).toObject();
      } else {
        const updateData = {
          "fileInput.image.max": curMembership.fileInput.image,
          "promptsLimit.max": curMembership.promptsLimit.max,
          resetDuration: curMembership.resetDuration,
          "fileInput.image.current": 0,
          "promptsLimit.current": 0,
        };

        featureData = await Feature.findOneAndUpdate(
          { userId },
          { $set: updateData },
          { new: true, lean: true }
        );
      }

      featureTime = {
        remPromptTime: featureData.resetDuration.prompts,
        remFileTime: featureData.resetDuration.fileInput,
        timestamp,
      };

      console.log("Feature from Database", { featureData, featureTime });
    } else {
      console.log("Updating feature data");
      await calculateRemTimes(featureTime, timestamp, featureData, userId);
    }

    await Promise.all([
      setToRedis(featureDataKey, featureData, 0),
      setToRedis(featureTimeKey, featureTime, 0),
      setListFromRedis("membership", allMemberships, expire.membership),
    ]);

    console.log("Feature after update", { ...featureData, ...featureTime });
  } catch (error) {
    console.error("Error in getFeature:", error);
    throw error;
  } finally {
    console.groupEnd();
  }

  return isUpdate ? { ...featureData, ...featureTime } : featureData;
};

const calculateRemTimes = async (
  featureTime,
  timestamp,
  featureData,
  userId
) => {
  const { remPromptTime, remFileTime } = featureTime;
  const { promptsLimit, fileInput } = featureData;
  const { prompts: promptResetDur, fileInput: fileResetDur } =
    featureData.resetDuration;

  const diff = (timestamp - featureTime.timestamp) / 1000;
  console.log("Difference:", diff);

  // Calculate remaining time for prompts
  let promptDiff = remPromptTime - diff;
  console.log("Prompt Difference:", promptDiff);
  if (promptDiff <= 0) {
    promptsLimit.current = 0;
    featureTime.remPromptTime = promptResetDur + (promptDiff % promptResetDur);
    console.log("Resetting prompts limit");
  } else {
    const promptCycles = Math.floor(promptDiff / promptResetDur);
    featureTime.remPromptTime = promptDiff - promptCycles * promptResetDur;
    if (featureTime.remPromptTime < 0) {
      featureTime.remPromptTime = 0;
    }
  }

  // Calculate remaining time for file input
  let fileDiff = remFileTime - diff;
  console.log("File Difference:", fileDiff);
  if (fileDiff <= 0) {
    fileInput.image.current = 0;
    featureTime.remFileTime = fileResetDur + (fileDiff % fileResetDur);
    console.log("Resetting file input limit");
  } else {
    const fileCycles = Math.floor(fileDiff / fileResetDur);
    featureTime.remFileTime = fileDiff - fileCycles * fileResetDur;
    if (featureTime.remFileTime < 0) {
      featureTime.remFileTime = 0;
    }
  }

  console.log("Calculated remaining times", {
    remPromptTime: featureTime.remPromptTime,
    remFileTime: featureTime.remFileTime,
  });

  if (promptDiff <= 0 || fileDiff <= 0) {
    console.log("Updating database due to reset times");
    await Feature.updateOne({ userId }, featureData);
  }

  featureTime.timestamp = timestamp;
};

module.exports = getFeature;
