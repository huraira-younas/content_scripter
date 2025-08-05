import { LOGIN } from "../../routes/routes";
import { postApi } from "../../utils/api_methods";
import { failure, request, success } from "../builder";
import { handleError, toaster } from "../../utils/handleError";

export const login = (credentials) => async (dispatch) => {
  const { remember } = credentials;
  dispatch(request({ type: "LOGIN_REQUEST" }));
  try {
    const admin = await postApi({ login: true, credentials, url: LOGIN });

    if (remember) {
      localStorage.setItem("admin", JSON.stringify(admin));
    } else {
      sessionStorage.setItem("admin", JSON.stringify(admin));
    }
    dispatch(success({ type: "LOGIN_SUCCESS", success: admin }));
    return toaster({ success: "login successfully" });
  } catch (error) {
    dispatch(failure({ type: "LOGIN_FAILURE", error: handleError(error) }));
    return toaster({ error: error });
  }
};

export const logout = () => ({
  type: "LOGOUT",
});
