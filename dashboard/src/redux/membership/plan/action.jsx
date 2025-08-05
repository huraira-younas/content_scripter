import {
  ADD_MEMBERSHIP,
  GET_MEMBERSHIP,
  UPDATE_MEMBERSHIP,
  DELETE_MEMBERSHIP,
} from "../../../routes/routes";
import { failure, request, success } from "../../builder";
import { removeAtIndex, updateIndexValue } from "../../../utils/utils";
import { getApi, getByIdApi, postApi } from "../../../utils/api_methods";
import { handleError, toaster } from "../../../utils/handleError";

export const getMembership = (_) => async (dispatch) => {
  dispatch(request({ type: "GET_MEMBERSHIP_REQUEST" }));
  try {
    const membership = await getApi({
      url: GET_MEMBERSHIP,
    });

    dispatch(success({ type: "GET_MEMBERSHIP_SUCCESS", success: membership }));
  } catch (error) {
    dispatch(
      failure({ type: "GET_MEMBERSHIP_FAILURE", error: handleError(error) })
    );
    return toaster({ error: error });
  }
};

export const addMembership = (credentials, memberships) => async (dispatch) => {
  dispatch(request({ type: "ADD_MEMBERSHIP_REQUEST" }));
  try {
    let membership = await postApi({
      credentials,
      url: ADD_MEMBERSHIP,
    });
    if (memberships.length) {
      membership = [membership, ...memberships];
    }

    dispatch(success({ type: "ADD_MEMBERSHIP_SUCCESS", success: membership }));
    return toaster({ success: "Added Successfully" });
  } catch (error) {
    dispatch(
      failure({ type: "ADD_MEMBERSHIP_FAILURE", error: handleError(error) })
    );
    return toaster({ error: error });
  }
};

export const updateMembership =
  (credentials, memberships) => async (dispatch) => {
    dispatch(request({ type: "UPDATE_MEMBERSHIP_REQUEST" }));
    try {
      let updatedInterest = await postApi({
        credentials,
        url: UPDATE_MEMBERSHIP,
      });

      let allInterests;
      const index = memberships?.findIndex(
        (int) => int._id === updatedInterest._id
      );
      console.log(index);
      if (index !== -1) {
        allInterests = updateIndexValue(memberships, updatedInterest, index);
      }

      dispatch(
        success({ type: "UPDATE_MEMBERSHIP_SUCCESS", success: allInterests })
      );
      return toaster({ success: "Updated Successfully" });
    } catch (error) {
      dispatch(
        failure({
          type: "UPDATE_MEMBERSHIP_FAILURE",
          error: handleError(error),
        })
      );
      return toaster({ error: error });
    }
  };

export const deleteMembership =
  (credentials, memberships) => async (dispatch) => {
    dispatch(request({ type: "DELETE_MEMBERSHIP_REQUEST" }));
    try {
      const message = await getByIdApi({
        credentials,
        isDelete: true,
        url: DELETE_MEMBERSHIP,
      });

      let allInterests;
      const index = memberships.findIndex((int) => int._id === credentials);
      if (index !== -1) {
        allInterests = removeAtIndex(memberships, index);
      }

      dispatch(
        success({ type: "DELETE_MEMBERSHIP_SUCCESS", success: allInterests })
      );
    } catch (error) {
      dispatch(
        failure({
          type: "DELETE_MEMBERSHIP_FAILURE",
          error: handleError(error),
        })
      );
      return toaster({ error: error });
    }
  };
