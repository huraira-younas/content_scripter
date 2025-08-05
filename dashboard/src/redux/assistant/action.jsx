import { failure, request, success } from "../builder";
import {
  deleteImage,
  getApi,
  getByIdApi,
  postApi,
} from "../../utils/api_methods";
import { handleError, toaster } from "../../utils/handleError";
import {
  ADD_ASSISTANT,
  DELETE_ASSISTANT,
  FILES_DELETE,
  GET_ASSISTANT,
  UPDATE_ASSISTANT,
} from "../../routes/routes";
import { removeAtIndex, updateIndexValue } from "../../utils/utils";

export const getAssistant = (_) => async (dispatch) => {
  dispatch(request({ type: "GET_ASSISTANT_REQUEST" }));
  try {
    const assistant = await getApi({
      url: GET_ASSISTANT,
    });

    dispatch(success({ type: "GET_ASSISTANT_SUCCESS", success: assistant }));
  } catch (error) {
    dispatch(
      failure({ type: "GET_ASSISTANT_FAILURE", error: handleError(error) })
    );
    return toaster({ error: error });
  }
};

export const addAssistant = (credentials, assistants) => async (dispatch) => {
  dispatch(request({ type: "ADD_ASSISTANT_REQUEST" }));
  try {
    let assistant = await postApi({
      credentials,
      url: ADD_ASSISTANT,
    });
    let allAssistant;
    if (assistants.length > 0) {
      allAssistant = [...assistants, assistant];
    }

    dispatch(success({ type: "ADD_ASSISTANT_SUCCESS", success: allAssistant }));
    return toaster({ success: "Added Successfully" });
  } catch (error) {
    dispatch(
      failure({ type: "ADD_ASSISTANT_FAILURE", error: handleError(error) })
    );
    return toaster({ error: error });
  }
};

export const updateAssistant =
  (credentials, assistants) => async (dispatch) => {
    dispatch(request({ type: "UPDATE_ASSISTANT_REQUEST" }));
    try {
      let updatedItem = await postApi({
        credentials,
        url: UPDATE_ASSISTANT,
      });

      let allAssistant;
      const index = assistants?.findIndex((ass) => ass._id === updatedItem._id);
      console.log(index);
      if (index !== -1) {
        allAssistant = updateIndexValue(assistants, updatedItem, index);
      }

      dispatch(
        success({ type: "UPDATE_ASSISTANT_SUCCESS", success: allAssistant })
      );
      return toaster({ success: "Updated Successfully" });
    } catch (error) {
      dispatch(
        failure({ type: "UPDATE_ASSISTANT_FAILURE", error: handleError(error) })
      );
      return toaster({ error: error });
    }
  };
export const deleteAssistant =
  (credentials, assistants) => async (dispatch) => {
    dispatch(request({ type: "DELETE_ASSISTANT_REQUEST" }));
    try {
      const message = await getByIdApi({
        credentials,
        isDelete: true,
        url: DELETE_ASSISTANT,
      });

      let allAssistant;
      const index = assistants.findIndex((ass) => ass._id === credentials);
      if (index !== -1) {
        allAssistant = removeAtIndex(assistants, index);
      }

      dispatch(
        success({ type: "DELETE_ASSISTANT_SUCCESS", success: allAssistant })
      );
    } catch (error) {
      dispatch(
        failure({ type: "DELETE_ASSISTANT_FAILURE", error: handleError(error) })
      );
      return toaster({ error: error });
    }
  };
