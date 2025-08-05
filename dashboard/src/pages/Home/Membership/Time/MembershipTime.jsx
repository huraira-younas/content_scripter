import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { removeAtIndex, updateIndexValue } from "../../../../utils/utils";
import { ToastContainer } from "react-toastify";
import { useFormik } from "formik";
import * as Yup from "yup";
import MembershipTimeScreen from "../../../../components/Screens/Home/Membership/Time/MembershipTimeScreen";
import MembershipTimeModal from "../../../../components/Screens/Home/Membership/Time/Modal/MembershipTimeModal";
import ConfirmModel from "../../../../components/common/ConfirmModel/ConfirmModel";
import {
  getMembershipTime,
  updateMembershipTime,
} from "../../../../redux/membership/time/action";
import { selectAdmin, selectMembershipTime } from "../../../selectors";

const MembershipTime = () => {
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [editDiscount, setEditDiscount] = useState("");
  const [showModal, setShowModal] = useState(false);
  const [editTitle, setEditTitle] = useState("");
  const [delIndex, setDelIndex] = useState(undefined);
  const [updateIndex, setUpdateIndex] = useState(undefined);
  const [isUpdate, setIsUpdate] = useState(false);
  const [isCreate, setIsCreate] = useState(undefined);
  const [selectedMembership, setSelectedMembership] = useState(null);
  const [values, setValues] = useState(undefined);

  const membershipTime = useSelector(selectMembershipTime);
  const admin = useSelector(selectAdmin);

  const dispatch = useDispatch();

  useEffect(() => {
    if (membershipTime.length) return;
    dispatch(getMembershipTime());
  }, []);

  const handleShowDeleteModal = (index) => {
    setShowDeleteModal(true);
    setDelIndex(index);
  };

  const handleCloseDeleteModal = () => {
    setShowDeleteModal(false);
  };

  const handleTitleChange = (value) => {
    setEditTitle(value);
  };

  const handleDiscountChange = (value) => {
    setEditDiscount(value);
  };

  const handleConfirmDelete = () => {
    if (delIndex === null || !membershipTime.length) return;
    const payload = {
      email: admin?.email,
      timePeriod: removeAtIndex(membershipTime, delIndex),
    };
    dispatch(updateMembershipTime(payload));
    handleCloseDeleteModal();
    setDelIndex(undefined);
  };

  const validationSchema = Yup.object().shape({
    discount: Yup.number().required("Discount is required"),
    time: Yup.number().required("Time is required"),
  });

  const formik = useFormik({
    validationSchema,
    initialValues: {
      discount: 0,
      time: 0,
    },
    onSubmit: (values) => {
      const { time, discount } = values;

      if ((!time && !discount) || (discount && !time)) return;
      const payload = {
        email: admin?.email,
        timePeriod: isUpdate
          ? updateIndexValue(
              membershipTime,
              { time, discount: discount / 100 },
              updateIndex
            )
          : [...membershipTime, { time, discount: discount / 100 }],
      };
      dispatch(updateMembershipTime(payload));
      handleCloseModal();
    },
  });

  const handleCloseModal = () => {
    if (isUpdate) {
      setUpdateIndex(undefined);
      setIsUpdate(false);
    }
    setShowModal(false);
    formik.resetForm({ time: 0, discount: 0 });
  };

  const handleShowModal = (time, discount, index) => {
    if (time === null || discount === null) {
      setIsCreate(true);
      setEditTitle("");
      setEditDiscount("");
    } else {
      setValues({ time, discount });
      setIsUpdate(true);
      setUpdateIndex(index);
      formik.setValues({ time: time, discount: discount });
    }
    setShowModal(true);
  };

  return (
    <>
      <MembershipTimeScreen
        showModal={handleShowModal}
        showDeleteModal={handleShowDeleteModal}
        membershipTime={membershipTime}
      />
      <MembershipTimeModal
        showModal={showModal}
        handleCloseModal={handleCloseModal}
        title={editTitle}
        discount={editDiscount}
        handleTitleChange={handleTitleChange}
        handleDiscountChange={handleDiscountChange}
        handleSubmit={formik.handleSubmit}
        handleChange={formik.handleChange}
        handleValue={formik.values}
        touched={formik.touched}
        errors={formik.errors}
        values={values}
      />
      <ConfirmModel
        showModal={showDeleteModal}
        handleCloseModal={handleCloseDeleteModal}
        handleConfirm={handleConfirmDelete}
      />
      <ToastContainer />
    </>
  );
};

export default MembershipTime;
