import { toast } from "react-toastify";
import { GET_USERS } from "../../routes/routes";
import { getUsersApi } from "../../utils/api_methods";
import { handleError } from "../../utils/handleError";
import { failure, request, success } from "../builder";

export const getUsers = (credentials) => async (dispatch) => {
  dispatch(request({ type: "USERS_REQUEST" }));
  try {
    const users = await getUsersApi({ credentials, url: GET_USERS });

    dispatch(success({ type: "USERS_SUCCESS", success: users }));
  } catch (error) {
    dispatch(failure({ type: "USERS_FAILURE", error: handleError(error) }));
    return toast.error(handleError(error));
  }
};

export const logout = () => ({
  type: "LOGOUT",
});
