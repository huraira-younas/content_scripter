export const ThemeChanger = (value) => async (dispatch) => {
  dispatch({
    type: "ThemeChanger",
    payload: value,
  });
};
