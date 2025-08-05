import React, { useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { useFormik } from "formik";
import * as Yup from "yup";
import { ToastContainer } from "react-toastify";
import {
  selectAdmin,
  selectPrompt,
  selectPromptGetLoader,
  selectPromptLoader,
} from "../../selectors";
import {
  addPrompt,
  getPrompt,
  updatePrompt,
} from "../../../redux/prompt/action";
import PromptScreen from "../../../components/Screens/Home/Prompt/PromptScreen";

const Prompt = () => {
  const admin = useSelector(selectAdmin);
  const prompt = useSelector(selectPrompt);
  const promptLoader = useSelector(selectPromptLoader);
  const promptGetLoader = useSelector(selectPromptGetLoader);

  const dispatch = useDispatch();
  const formik = useFormik({
    initialValues: {
      defaultPrompt: "",
      model: "",
      modelApiKey: "",
      tagsApiKey: "",
    },
    onSubmit: (values) => {
      let payload = {
        email: admin?.email,
        ...values,
      };

      if (!Object.keys(prompt).length) {
        dispatch(addPrompt(payload));
      } else {
        payload.promptModelId = prompt._id;
        dispatch(updatePrompt(payload));
      }
    },
    validationSchema: Yup.object().shape({
      defaultPrompt: Yup.string().required("deafault prompt is required"),
      modelApiKey: Yup.string().required("model api key is required"),
      tagsApiKey: Yup.string().required("tags api key is required"),
      model: Yup.string().required("model is required"),
    }),
  });

  useEffect(() => {
    if (Object.keys(prompt).length > 0) {
      formik.setValues({
        defaultPrompt: prompt.defaultPrompt,
        modelApiKey: prompt.modelApiKey,
        tagsApiKey: prompt.tagsApiKey,
        model: prompt.model,
      });
    } else {
      dispatch(getPrompt());
    }
  }, [prompt]);

  return (
    <>
      <PromptScreen
        loader={promptLoader || promptGetLoader}
        handleChange={formik.handleChange}
        handleSubmit={formik.handleSubmit}
        handleValue={formik.values}
        touched={formik.touched}
        errors={formik.errors}
        prompt={prompt}
      />

      <ToastContainer />
    </>
  );
};

export default Prompt;
