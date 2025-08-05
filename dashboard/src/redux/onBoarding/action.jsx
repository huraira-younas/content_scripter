import { failure, request, success } from "../builder";
import {
  deleteImage,
  getApi,
  getByIdApi,
  postApi,
} from "../../utils/api_methods";
import { handleError, toaster } from "../../utils/handleError";
import {
  ADD_ONBOARDING,
  DELETE_ONBOARDING,
  FILES_DELETE,
  GET_ONBOARDING,
  UPDATE_ONBOARDING,
} from "../../routes/routes";
import { removeAtIndex, updateIndexValue } from "../../utils/utils";

export const getOnBoarding = (_) => async (dispatch) => {
  dispatch(request({ type: "GET_ONBOARDING_REQUEST" }));
  try {
    const onboarding = await getApi({
      url: GET_ONBOARDING,
    });

    dispatch(success({ type: "GET_ONBOARDING_SUCCESS", success: onboarding }));
  } catch (error) {
    dispatch(
      failure({ type: "GET_ONBOARDING_FAILURE", error: handleError(error) })
    );
    return toaster({ error: error });
  }
};

export const addOnBoarding = (credentials, onboard) => async (dispatch) => {
  dispatch(request({ type: "ADD_ONBOARDING_REQUEST" }));
  try {
    let onboarding = await postApi({
      credentials,
      url: ADD_ONBOARDING,
    });
    let allOnboarding;
    if (onboard.length > 0) {
      allOnboarding = [...onboard, onboarding];
    }

    dispatch(
      success({ type: "ADD_ONBOARDING_SUCCESS", success: allOnboarding })
    );
    return toaster({ success: "Added Successfully" });
  } catch (error) {
    dispatch(
      failure({ type: "ADD_ONBOARDING_FAILURE", error: handleError(error) })
    );
    return toaster({ error: error });
  }
};

export const updateOnBoarding = (credentials, onboard) => async (dispatch) => {
  dispatch(request({ type: "UPDATE_ONBOARDING_REQUEST" }));
  try {
    let updatedItem = await postApi({
      credentials,
      url: UPDATE_ONBOARDING,
    });

    let allOnboarding;
    const index = onboard?.findIndex((onb) => onb._id === updatedItem._id);
    console.log(index);
    if (index !== -1) {
      allOnboarding = updateIndexValue(onboard, updatedItem, index);
    }

    dispatch(
      success({ type: "UPDATE_ONBOARDING_SUCCESS", success: allOnboarding })
    );
    return toaster({ success: "Updated Successfully" });
  } catch (error) {
    dispatch(
      failure({ type: "UPDATE_ONBOARDING_FAILURE", error: handleError(error) })
    );
    return toaster({ error: error });
  }
};
export const deleteOnBoarding = (credentials, ondoard) => async (dispatch) => {
  dispatch(request({ type: "DELETE_ONBOARDING_REQUEST" }));
  try {
    const message = await getByIdApi({
      credentials,
      isDelete: true,
      url: DELETE_ONBOARDING,
    });

    let allOnboarding;
    const index = ondoard.findIndex((onb) => onb._id === credentials);
    if (index !== -1) {
      allOnboarding = removeAtIndex(ondoard, index);
    }

    dispatch(
      success({ type: "DELETE_ONBOARDING_SUCCESS", success: allOnboarding })
    );
  } catch (error) {
    dispatch(
      failure({ type: "DELETE_ONBOARDING_FAILURE", error: handleError(error) })
    );
    return toaster({ error: error });
  }
};
