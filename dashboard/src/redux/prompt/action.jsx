import { ADD_PROMPT, GET_PROMPT, UPDATE_PROMPT } from "../../routes/routes";
import { failure, request, success } from "../builder";
import { getApi, postApi } from "../../utils/api_methods";
import { handleError, toaster } from "../../utils/handleError";

export const getPrompt = (_) => async (dispatch) => {
  dispatch(request({ type: "GET_PROMPT_REQUEST" }));
  try {
    const prompt = await getApi({
      url: GET_PROMPT,
    });

    dispatch(success({ type: "GET_PROMPT_SUCCESS", success: prompt }));
  } catch (error) {
    dispatch(
      failure({ type: "GET_PROMPT_FAILURE", error: handleError(error) })
    );
    return toaster({ error: error });
  }
};

export const addPrompt = (credentials) => async (dispatch) => {
  dispatch(request({ type: "ADD_PROMPT_REQUEST" }));
  try {
    const prompt = await postApi({
      credentials,
      url: ADD_PROMPT,
    });

    dispatch(success({ type: "ADD_PROMPT_SUCCESS", success: prompt }));
    return toaster({ success: "Added Successfully" });
  } catch (error) {
    dispatch(
      failure({ type: "ADD_PROMPT_FAILURE", error: handleError(error) })
    );
    return toaster({ error: error });
  }
};

export const updatePrompt = (credentials) => async (dispatch) => {
  dispatch(request({ type: "UPDATE_PROMPT_REQUEST" }));
  try {
    const prompt = await postApi({
      credentials,
      url: UPDATE_PROMPT,
    });

    dispatch(success({ type: "UPDATE_PROMPT_SUCCESS", success: prompt }));
    return toaster({ success: "Updated Successfully" });
  } catch (error) {
    dispatch(
      failure({ type: "UPDATE_PROMPT_FAILURE", error: handleError(error) })
    );
    return toaster({ error: error });
  }
};
