import * as Yup from "yup";
import { useFormik } from "formik";
import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { ToastContainer, toast } from "react-toastify";
import {
  addOnBoarding,
  updateOnBoarding,
} from "../../../../redux/onBoarding/action";
import {
  selectAdmin,
  selectAssistant,
  selectDeleteAssistantLoader,
  selectOnBoarding,
  selectUpdateOnboardingLoader,
} from "../../../selectors";
import {
  FILES_DELETE,
  FILES_UPLOAD,
  GET_ASSISTANT_BYID,
} from "../../../../routes/routes";
import {
  deleteImage,
  getById,
  uploadImage,
} from "../../../../utils/api_methods";
import { useParams } from "react-router-dom";
import {
  addAssistant,
  updateAssistant,
} from "../../../../redux/assistant/action";
import CreateScreen from "../../../../components/Screens/Home/Assistant/Create/CreateScreen";

const Create = () => {
  const [file, setFile] = useState(null);
  const loader = useSelector(selectDeleteAssistantLoader);
  const assistant = useSelector(selectAssistant);
  const [imgLoader, setImgLoader] = useState(false);
  const [getLoader, setGetLoader] = useState(false);
  const admin = useSelector(selectAdmin);
  const [initialValues, setInitialValues] = useState(null);

  const handleFileChange = (event) => {
    setFile(event.target.files[0]);
  };
  const dispatch = useDispatch();
  const id = useParams()?.id;

  useEffect(() => {
    if (id) {
      const fetch = async () => {
        try {
          setGetLoader(true);
          const data = await getById({ url: `${GET_ASSISTANT_BYID}/${id}` });
          formik.setValues({
            icon: data.icon,
            description: data.description,
            prompt: data.prompt,
            category: data.category,
            topic: data.topic,
          });
          setInitialValues({
            ...data,
          });
        } catch (error) {
          toast.error(error, { theme: "colored" });
        } finally {
          setGetLoader(false);
        }
      };
      fetch();
    }
  }, [id]);

  useEffect(() => {
    formik.setValues({
      icon: "",
      description: "",
      prompt: "",
      category: "",
      topic: "",
    });
  }, [!id]);

  const validationSchema = Yup.object().shape({
    topic: Yup.string().required("topic is required"),
    description: Yup.string().required("description is required"),
    prompt: Yup.string().required("prompt is required"),
    category: Yup.string().required("category is required"),
  });
  const formik = useFormik({
    validationSchema,
    initialValues: {
      icon: "",
      description: "",
      prompt: "",
      category: "",
      topic: "",
    },
    onSubmit: async (values) => {
      const { prompt, category, description, topic } = values;
      let imageUrl = values.icon;

      if (!id && !file) {
        formik.setErrors({ icon: "Please select an image" });
        return;
      }

      try {
        setImgLoader(true);
        if (id && file) {
          await deleteImage({ url: FILES_DELETE, imgUrl: imageUrl });
        }
        if (file) {
          const response = await uploadImage({
            file,
            url: FILES_UPLOAD,
            id: admin?._id,
          });
          imageUrl = response.data;
        }
        const payload = {
          email: admin?.email,
          ...values,
          icon: imageUrl,
        };

        if (id) {
          await dispatch(
            updateAssistant({ ...payload, assistantId: id }, assistant)
          );
          formik.setValues({
            icon: file ? imageUrl : values.icon,
            prompt,
            topic,
            description,
            category,
          });
          setInitialValues(values);
          if (file) setFile(null);
        } else {
          await dispatch(addAssistant(payload, assistant));
          if (file) setFile(null);
          formik.resetForm();
        }
      } catch (error) {
        const err = error.message;
        if (file) {
          deleteImage({ url: FILES_DELETE, imgUrl: imageUrl });
        }
        toast.error(err);
      } finally {
        if (file) setFile(null);
        setImgLoader(false);
      }
    },
  });

  return (
    <>
      <CreateScreen
        handleFileChange={handleFileChange}
        handleSubmit={formik.handleSubmit}
        handleChange={formik.handleChange}
        initialValues={initialValues}
        loader={loader || imgLoader}
        handleValue={formik.values}
        touched={formik.touched}
        errors={formik.errors}
        imgLoader={imgLoader}
        getLoader={getLoader}
        file={file}
        id={id}
      />
      <ToastContainer />
    </>
  );
};

export default Create;
