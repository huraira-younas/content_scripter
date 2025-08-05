import {
  GET_MEMBERSHIP_TIME,
  UPDATE_MEMBERSHIP_TIME,
} from "../../../routes/routes";
import { failure, request, success } from "../../builder";
import { handleError, toaster } from "../../../utils/handleError";
import { getApi, postApi } from "../../../utils/api_methods";

export const getMembershipTime = (_) => async (dispatch) => {
  dispatch(request({ type: "GET_MEMBERSHIPTIME_REQUEST" }));
  try {
    const membership = await getApi({
      url: GET_MEMBERSHIP_TIME,
    });

    dispatch(
      success({ type: "GET_MEMBERSHIPTIME_SUCCESS", success: membership })
    );
  } catch (error) {
    dispatch(
      failure({ type: "GET_MEMBERSHIPTIME_FAILURE", error: handleError(error) })
    );
    return toaster({ error: error });
  }
};

export const updateMembershipTime = (credentials) => async (dispatch) => {
  dispatch(request({ type: "UPDATE_MEMBERSHIPTIME_REQUEST" }));
  try {
    const membership = await postApi({
      credentials,
      url: UPDATE_MEMBERSHIP_TIME,
    });

    dispatch(
      success({ type: "UPDATE_MEMBERSHIPTIME_SUCCESS", success: membership })
    );
    return toaster({ success: "Updated Successfully" });
  } catch (error) {
    dispatch(
      failure({
        type: "UPDATE_MEMBERSHIPTIME_FAILURE",
        error: handleError(error),
      })
    );
    return toaster({ error: error });
  }
};
