export const handleWheel = (event, inputRef) => {
  event.preventDefault();
  if (inputRef && inputRef.current) {
    inputRef.current.blur();
  }
};

export const calculateDays = (days) => {
  if (days >= 365) {
    let years = Math.floor(days / 365);
    return years === 1 ? "1 year" : years + " years";
  } else if (days >= 30) {
    let months = Math.floor(days / 30);
    return months === 1 ? "1 month" : months + " months";
  } else if (days >= 7) {
    let weeks = Math.floor(days / 7);
    return weeks === 1 ? "1 week" : weeks + " weeks";
  } else {
    return days === 1 ? "1 day" : days + " days";
  }
};

function convertSeconds(seconds) {
  let remainingSeconds = seconds;

  const numMonths = Math.floor(remainingSeconds / (30 * 24 * 60 * 60));
  remainingSeconds %= 30 * 24 * 60 * 60;

  const numDays = Math.floor(remainingSeconds / (24 * 60 * 60));
  remainingSeconds %= 24 * 60 * 60;

  const numHours = Math.floor(remainingSeconds / (60 * 60));
  remainingSeconds %= 60 * 60;

  const numMinutes = Math.floor(remainingSeconds / 60);

  return {
    months: numMonths,
    days: numDays,
    hours: numHours,
    minutes: numMinutes,
  };
}

export const formatTime = (seconds, update = false) => {
  const timeValues = convertSeconds(seconds);
  if (timeValues.months > 0) {
    return `${timeValues.months}${!update ? "month" : ""}`;
  } else if (timeValues.days > 0) {
    const daysString = `${timeValues.days}${
      !update ? `day${timeValues.days !== 1 ? "s" : ""}` : ""
    }`;
    const hoursString =
      timeValues.hours > 0
        ? `${timeValues.hours}${
            !update ? `hour${timeValues.hours !== 1 ? "s" : ""}` : ""
          }`
        : "";
    const minutesString =
      timeValues.minutes > 0
        ? `${timeValues.minutes}${
            !update ? `minute${timeValues.minutes !== 1 ? "s" : ""}` : ""
          }`
        : "";
    return `${daysString}${hoursString}${minutesString}`.trim();
  } else if (timeValues.hours > 0) {
    return `${timeValues.hours}${
      !update ? `hour${timeValues.hours !== 1 ? "s" : ""}` : ""
    }`;
  } else {
    return `${timeValues.minutes} ${
      !update ? `minute${timeValues.minutes !== 1 ? "s" : ""}` : ""
    }`;
  }
};

export const removeAtIndex = (arr, index) => {
  if (!arr.length || index >= arr.length) return;
  return arr.slice(0, index).concat(arr.slice(index + 1));
};

export const handleInputChange = (e, handleChange) => {
  const value = e.target.value;
  const regex = /^[0-9\b]+$/;
  if (value === "" || regex.test(value)) {
    handleChange(e);
  }
};

export const updateIndexValue = (arr, value, index) => {
  if (!arr.length || index >= arr.length) return;
  return [...arr.slice(0, index), value, ...arr.slice(index + 1)];
};

export const compareObjects = (obj1, obj2, excludeKeys = []) => {
  function allKeys(obj) {
    return new Set([...Object.keys(obj1), ...Object.keys(obj2)]);
  }

  function isObject(obj) {
    return obj && typeof obj === "object" && !Array.isArray(obj);
  }

  function compareValues(val1, val2) {
    if (isObject(val1) && isObject(val2)) {
      return compareObjects(val1, val2, excludeKeys);
    }
    if (typeof val1 === "string" && typeof val2 === "string") {
      return val1.trim() === val2.trim();
    }
    return val1 === val2;
  }

  const sortedKeys = [...allKeys()]
    .sort()
    .filter((key) => !excludeKeys.includes(key));

  for (const key of sortedKeys) {
    const val1 = obj1[key] ?? obj2[key];
    const val2 = obj2[key] ?? obj1[key];

    if (!compareValues(val1, val2)) {
      return false;
    }
  }

  return true;
};
