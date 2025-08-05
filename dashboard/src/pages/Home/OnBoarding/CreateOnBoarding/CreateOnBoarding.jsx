import React, { useEffect, useState } from "react";
import { useFormik } from "formik";
import * as Yup from "yup";
import { useDispatch, useSelector } from "react-redux";
import { ToastContainer, toast } from "react-toastify";
import CreateOnBoardingScreen from "../../../../components/Screens/Home/OnBoarding/CreateOnBoarding/CreateOnBoardingScreen";
import {
  addOnBoarding,
  updateOnBoarding,
} from "../../../../redux/onBoarding/action";
import {
  selectAdmin,
  selectOnBoarding,
  selectUpdateOnboardingLoader,
} from "../../../selectors";
import {
  FILES_DELETE,
  FILES_UPLOAD,
  GET_ONBOARDING_BYID,
} from "../../../../routes/routes";
import {
  deleteImage,
  getById,
  uploadImage,
} from "../../../../utils/api_methods";
import { useParams } from "react-router-dom";

const CreateOnBoarding = () => {
  const [file, setFile] = useState(null);
  const loader = useSelector(selectUpdateOnboardingLoader);
  const onBoarding = useSelector(selectOnBoarding);
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
          const data = await getById({ url: `${GET_ONBOARDING_BYID}/${id}` });
          formik.setValues({
            title: data.title,
            description: data.description,
            index: data.index,
            imageUrl: data.imageUrl,
          });
          setInitialValues({
            ...data,
          });
        } catch (error) {
          toast.error(error);
        } finally {
          setGetLoader(false);
        }
      };
      fetch();
    }
  }, [id]);

  useEffect(() => {
    formik.setValues({
      title: "",
      imageUrl: "",
      description: "",
      index: 0,
    });
  }, [!id]);

  const validationSchema = Yup.object().shape({
    title: Yup.string().required("title is required"),
    description: Yup.string().required("description is required"),
    index: Yup.number().required("index is required"),
  });
  const formik = useFormik({
    validationSchema,
    initialValues: {
      title: "",
      imageUrl: "",
      description: "",
      index: 0,
    },
    onSubmit: async (values) => {
      const { title, description, index } = values;
      let imageUrl = values.imageUrl;

      if (!id && !file) {
        formik.setErrors({ imageUrl: "Please select an image" });
        return;
      }

      if (onBoarding?.some((onboarding) => onboarding.index === index))
        formik.setErrors({ index: "page already exist" });

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
          imageUrl,
        };

        if (id) {
          await dispatch(
            updateOnBoarding({ ...payload, pageId: id }, onBoarding)
          );
          formik.setValues({
            imageUrl: file ? imageUrl : values.imageUrl,
            title,
            description,
            index,
          });
          setInitialValues(values);
          if (file) setFile(null);
        } else {
          await dispatch(addOnBoarding(payload, onBoarding, imageUrl));
          formik.resetForm();
          setFile(null);
        }
        if (imgLoader) setImgLoader(false);
      } catch (error) {
        const err = error.message;
        if (file) {
          deleteImage({ url: FILES_DELETE, imgUrl: imageUrl });
        }
        toast.error(err);
      }
    },
  });

  return (
    <>
      <CreateOnBoardingScreen
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

export default CreateOnBoarding;
