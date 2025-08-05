import React, { useEffect, useState } from "react";
import { useFormik } from "formik";
import * as Yup from "yup";
import { useDispatch, useSelector } from "react-redux";
import { ToastContainer, toast } from "react-toastify";
import { formatTime } from "../../../../utils/utils";
import { GET_MEMBERSHIP_BYID } from "../../../../routes/routes";
import {
  selectAdmin,
  selectMembership,
  selectMembershipLoader,
} from "../../../selectors";
import {
  addMembership,
  updateMembership,
} from "../../../../redux/membership/plan/action";
import CreateMembershipScreen from "../../../../components/Screens/Home/Membership/Plan/Create/CreateMembershipScreen";
import { getById } from "../../../../utils/api_methods";
import { useParams } from "react-router-dom";

const CreateMembership = () => {
  const [inputValue, setInputValue] = useState("");
  const [value, setValue] = useState([]);

  const [featureError, setFeatureError] = useState("");
  const dispatch = useDispatch();
  const [updateLoader, setUpdateLoader] = useState(false);
  const [initialValues, setInitialValues] = useState(null);

  const [seconds, setSeconds] = useState(0);
  const [multipliedTime, setMultipliedTime] = useState("");

  const admin = useSelector(selectAdmin);
  const memberships = useSelector(selectMembership);
  const membershipLoader = useSelector(selectMembershipLoader);
  const id = useParams()?.id;

  const getSeconds = (timeString) => {
    const lowerCaseTimeString = timeString.toLowerCase();
    if (lowerCaseTimeString.includes("day")) return 86400;
    if (lowerCaseTimeString.includes("month")) return 2592000;
    if (lowerCaseTimeString.includes("hour")) return 3600;
    if (lowerCaseTimeString.includes("minute")) return 60;
    return 0;
  };

  useEffect(() => {
    formik.resetForm();
  }, [!id]);

  useEffect(() => {
    if (id) {
      const fetch = async () => {
        try {
          setUpdateLoader(true);
          const data = await getById({ url: `${GET_MEMBERSHIP_BYID}/${id}` });
          formik.setValues({
            title: data.title,
            price: data.price,
            fileInput: {
              image: data.fileInput.image === -1 ? "" : data.fileInput.image,
              unlimited: data.fileInput.image === -1,
            },
            promptsLimit: {
              max: data.promptsLimit.max,
              unlimited: data.fileInput.image === -1,
            },
            resetDuration: {
              fileInput:
                data.resetDuration.fileInput === -1
                  ? ""
                  : formatTime(data.resetDuration.fileInput, true),
              fileSeconds: getSeconds(formatTime(data.resetDuration.fileInput)),
              promptSeconds: getSeconds(formatTime(data.resetDuration.prompts)),
              prompts:
                data.resetDuration.prompts === -1
                  ? ""
                  : formatTime(data.resetDuration.prompts, true),
            },
            isAdsOn: !data.isAdsOn ? "false" : "true",
          });
          setValue(
            data?.features?.map((feature) => ({
              label: feature,
              value: feature,
            }))
          );
        } catch (error) {
          toast.error(error);
        } finally {
          setUpdateLoader(false);
        }
      };
      fetch();
    }
  }, []);

  const validationSchema = Yup.object().shape({
    title: Yup.string().required("Title is required"),
    price: Yup.number().required("Price is required"),
    fileInput: Yup.object().shape({
      image: Yup.number()
        .required("Image is required")
        .positive("Image must be a positive number"),
    }),
    promptsLimit: Yup.object().shape({
      max: Yup.number()
        .required("Max prompts limit is required")
        .positive("Max prompts limit must be a positive number"),
    }),
    resetDuration: Yup.object().shape({
      fileInput: Yup.number()
        .required("File upload reset duration is required")
        .positive("File upload reset duration must be a positive number"),
      fileSeconds: Yup.number().moreThan(
        1,
        "File upload reset duration is required"
      ),
      promptSeconds: Yup.number().moreThan(
        1,
        "Prompts reset duration is required"
      ),
      prompts: Yup.number()
        .required("Prompts reset duration is required")
        .positive("Prompts reset duration must be a positive number"),
    }),
  });

  const formik = useFormik({
    validationSchema,
    initialValues: {
      title: "",
      price: 0,
      fileInput: {
        image: 0,
        unlimited: false,
      },
      promptsLimit: {
        max: 0,
        unlimited: false,
      },
      resetDuration: {
        fileInput: 0,
        fileSeconds: 0,
        promptSeconds: 0,
        prompts: 0,
      },
      isAdsOn: "false",
    },

    onSubmit: (values) => {
      if (!value.length) {
        setFeatureError("Enter membership features ");
        return;
      }
      const unlFile = values.fileInput.unlimited;
      const img = values.fileInput.image;
      const unlPrompt = values.promptsLimit.unlimited;
      const pro = values.promptsLimit.max;
      const resFile = values.resetDuration.fileInput;
      const resFileSec = values.resetDuration.fileSeconds;
      const resPrompt = values.resetDuration.prompts;
      const resPromptSec = values.resetDuration.promptSeconds;
      const filePayload = { image: unlFile ? -1 : img };
      const promptPayload = { max: unlPrompt ? -1 : pro };
      const resDurPay = {
        fileInput: resFile * resFileSec,
        prompts: resPrompt * resPromptSec,
      };

      const payload = {
        email: admin?.email,
        ...values,
        fileInput: filePayload,
        promptsLimit: promptPayload,
        resetDuration: resDurPay,
        features: value.map((item) => item.value),
      };
      if (id) {
        payload.membershipPlanId = id;
        dispatch(updateMembership(payload, memberships));
      } else {
        dispatch(addMembership(payload, memberships));
        formik.resetForm();
        setValue([]);
      }
      setFeatureError("");
    },
  });

  const handleKeyDown = (event) => {
    if (!inputValue) return;
    switch (event.key) {
      case "Enter":
      case "Tab":
        setValue((prev) => [...prev, createOption(inputValue)]);
        setInputValue("");
        event.preventDefault();
    }
  };

  const createOption = (label) => ({
    label,
    value: label,
  });

  return (
    <>
      <CreateMembershipScreen
        handleSubmit={formik.handleSubmit}
        handleChange={formik.handleChange}
        handleKeyDown={handleKeyDown}
        setInputValue={setInputValue}
        handleValue={formik.values}
        touched={formik.touched}
        inputValue={inputValue}
        errors={formik.errors}
        setValue={setValue}
        value={value}
        id={id}
        featureError={featureError}
        initialValues={initialValues}
        setInitialValues={setInitialValues}
        setSeconds={setSeconds}
        seconds={seconds}
        multipliedTime={multipliedTime}
        setMultipliedTime={setMultipliedTime}
        loader={updateLoader || membershipLoader}
      />
      <ToastContainer />
    </>
  );
};

export default CreateMembership;
