export const request = ({ type }) => ({
  type: type,
});

export const success = ({ type, success }) => ({
  type: type,
  payload: success,
});

export const failure = ({ type, error }) => ({
  type: type,
  payload: error,
});
