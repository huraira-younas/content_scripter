import { getApi, postApi } from "../../utils/api_methods";
import { GET_HELPCENTER, UPDATE_HELPCENTER } from "../../routes/routes";
import { failure, request, success } from "../builder";
import { handleError, toaster } from "../../utils/handleError";

export const getHelpCenter = (_) => async (dispatch) => {
  dispatch(request({ type: "GET_HELPCENTER_REQUEST" }));
  try {
    const helpCenter = await getApi({
      url: GET_HELPCENTER,
    });

    dispatch(success({ type: "GET_HELPCENTER_SUCCESS", success: helpCenter }));
  } catch (error) {
    dispatch(
      failure({ type: "GET_HELPCENTER_FAILURE", error: handleError(error) })
    );
    return toaster({ error: error });
  }
};

export const addHelpCenter = (credentials) => async (dispatch) => {
  dispatch(request({ type: "ADD_HELPCENTER_REQUEST" }));
  try {
    const helpCenter = await postApi({
      credentials,
      url: UPDATE_HELPCENTER,
    });

    dispatch(success({ type: "ADD_HELPCENTER_SUCCESS", success: helpCenter }));
    return toaster({ success: "Added Successfully" });
  } catch (error) {
    dispatch(
      failure({ type: "ADD_HELPCENTER_FAILURE", error: handleError(error) })
    );
    return toaster({ error: error });
  }
};

export const updateHelpCenter = (credentials) => async (dispatch) => {
  dispatch(request({ type: "UPDATE_HELPCENTER_REQUEST" }));
  try {
    const helpCenter = await postApi({
      credentials,
      url: UPDATE_HELPCENTER,
    });

    dispatch(
      success({ type: "UPDATE_HELPCENTER_SUCCESS", success: helpCenter })
    );
    return toaster({ success: "Updated Successfully" });
  } catch (error) {
    dispatch(
      failure({ type: "UPDATE_HELPCENTER_FAILURE", error: handleError(error) })
    );
    return toaster({ error: error });
  }
};

export const deleteHelpCenter = (credentials) => async (dispatch) => {
  dispatch(request({ type: "DELETE_HELPCENTER_REQUEST" }));
  try {
    const helpCenter = await postApi({
      credentials,
      url: UPDATE_HELPCENTER,
    });

    dispatch(
      success({ type: "DELETE_HELPCENTER_SUCCESS", success: helpCenter })
    );
    return toaster({ success: "Deleted Successfully" });
  } catch (error) {
    dispatch(
      failure({ type: "DELETE_HELPCENTER_FAILURE", error: handleError(error) })
    );
    return toaster({ error: error });
  }
};
