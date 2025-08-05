import React, { useEffect, useState } from "react";
import * as Yup from "yup";
import { useDispatch, useSelector } from "react-redux";
import { ToastContainer, toast } from "react-toastify";
import { useFormik } from "formik";
import {
  selectAdmin,
  selectHelpCenter,
  selectUpdateLoader,
} from "../../../selectors";
import ContactScreen from "../../../../components/Screens/Home/Setting/Contact/ContactScreen";
import ConfirmModel from "../../../../components/common/ConfirmModel/ConfirmModel";
import { deleteImage, uploadImage } from "../../../../utils/api_methods";
import { removeAtIndex, updateIndexValue } from "../../../../utils/utils";
import {
  addHelpCenter,
  deleteHelpCenter,
  getHelpCenter,
  updateHelpCenter,
} from "../../../../redux/setting/action";
import { FILES_DELETE, FILES_UPLOAD } from "../../../../routes/routes";
import Model from "../../../../components/Screens/Home/Setting/Contact/Model/Model";

const ContactUs = () => {
  const [showModal, setShowModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [delIndex, setDelIndex] = useState(null);
  const [isUpdate, setIsUpdate] = useState(false);
  const [updateIndex, setUpdateIndex] = useState(undefined);
  const [isCreate, setIsCreate] = useState(undefined);
  const [selfLoader, setSelfLoader] = useState(false);
  const [values, setValues] = useState(undefined);

  const dispatch = useDispatch();
  const admin = useSelector(selectAdmin);
  const helpcenter = useSelector(selectHelpCenter);
  const updateLoader = useSelector(selectUpdateLoader);

  const [fileOne, setFileOne] = useState(null);
  const handleFileOneChange = (event) => {
    setFileOne(event.target.files[0]);
  };

  const handleDelete = async () => {
    if (delIndex === null || !helpcenter.contactUs.length) return;
    try {
      setSelfLoader(true);
      const response = await deleteImage({
        url: FILES_DELETE,
        imgUrl: helpcenter?.contactUs[delIndex]?.icon,
      });
      if (response.status === 200) {
        const updatedItems = removeAtIndex(helpcenter.contactUs, delIndex);
        const payload = {
          email: admin?.email,
          ...helpcenter,
          contactUs: updatedItems,
        };
        dispatch(deleteHelpCenter(payload));
      }
    } catch (error) {
      toast.error(error);
    } finally {
      setSelfLoader(false);
      handleCloseDeleteModal();
      setDelIndex(undefined);
    }
  };

  const formik = useFormik({
    initialValues: {
      icon: "",
      title: "",
      text: "",
    },
    onSubmit: async (values) => {
      const { contactUs } = helpcenter;
      const { icon, title, text } = values;
      let imageUrl = icon;
      if (!title || !text) return;
      if (!fileOne && !isUpdate) {
        formik.setErrors({ icon: "Select Icon." });
        return;
      }
      try {
        setSelfLoader(true);
        if (fileOne) {
          const response = await uploadImage({
            file: fileOne,
            url: FILES_UPLOAD,
            id: admin?._id,
          });
          imageUrl = response.data;
        }
        const payload = {
          email: admin?.email,
          ...helpcenter,
          contactUs: isUpdate
            ? updateIndexValue(
                contactUs,
                { icon: imageUrl, title, text },
                updateIndex
              )
            : [{ icon: imageUrl, title, text }, ...contactUs],
        };
        if (isUpdate) {
          dispatch(updateHelpCenter(payload));
        } else {
          dispatch(addHelpCenter(payload));
        }
        if (isUpdate && fileOne && contactUs[updateIndex]?.icon) {
          await deleteImage({
            url: FILES_DELETE,
            imgUrl: contactUs[updateIndex].icon,
          });
        }
        setShowModal(false);
        formik.resetForm();
        setFileOne(null);
      } catch (error) {
        const err = error.message;
        if (imageUrl) {
          await deleteImage({ url: FILES_DELETE, imgUrl: imageUrl });
        }
        toast.error(err);
      } finally {
        setSelfLoader(false);
        setShowModal(false);
        formik.resetForm();
        setFileOne(null);
      }
    },
    validationSchema: Yup.object().shape({
      title: Yup.string().required("Title is required"),
      text: Yup.string().required("Link is required"),
    }),
  });

  const handleShowDeleteModal = (delIndex) => {
    setShowDeleteModal(true);
    setDelIndex(delIndex);
  };
  const handleCloseDeleteModal = () => {
    setShowDeleteModal(false);
  };

  const handleShowModal = (icon, title, text, index) => {
    if (icon === null || title === null || text === null) {
      setIsCreate(true);
    } else {
      setValues({ title, text, icon });
      setIsUpdate(true);
      setUpdateIndex(index);
      formik.setValues({ icon: icon, title: title, text: text });
    }
    setShowModal(true);
  };

  const handleCloseModal = () => {
    if (isUpdate) {
      setUpdateIndex(undefined);
      setIsUpdate(false);
    }
    setShowModal(false);
    formik.resetForm();
    setFileOne(null);
  };

  useEffect(() => {
    if (!Object.keys(helpcenter).length) dispatch(getHelpCenter());
  }, []);

  return (
    <>
      <ContactScreen
        showModal={handleShowModal}
        showDeleteModal={handleShowDeleteModal}
      />
      <Model
        handleFileOneChange={handleFileOneChange}
        loader={selfLoader || updateLoader}
        handleCloseModal={handleCloseModal}
        handleSubmit={formik.handleSubmit}
        handleChange={formik.handleChange}
        handleValue={formik.values}
        touched={formik.touched}
        errors={formik.errors}
        showModal={showModal}
        isUpdate={isUpdate}
        fileOne={fileOne}
        values={values}
      />
      <ConfirmModel
        showModal={showDeleteModal}
        handleConfirm={handleDelete}
        loader={selfLoader || updateLoader}
        handleCloseModal={handleCloseDeleteModal}
      />
      <ToastContainer />
    </>
  );
};

export default ContactUs;
