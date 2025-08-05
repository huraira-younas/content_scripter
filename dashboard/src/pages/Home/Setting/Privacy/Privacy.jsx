import * as Yup from "yup";
import { useFormik } from "formik";
import { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import {
  addHelpCenter,
  getHelpCenter,
  updateHelpCenter,
} from "../../../../redux/setting/action";
import { selectAdmin, selectHelpCenter } from "../../../selectors";
import PrivacyScreen from "../../../../components/Screens/Home/Setting/Privacy/PrivacyScreen";
import { ToastContainer } from "react-toastify";

const PrivacyPolicy = () => {
  const dispatch = useDispatch();
  const admin = useSelector(selectAdmin);
  const helpcenter = useSelector(selectHelpCenter);
  const [originalPrivacyPolicy, setOriginalPrivacyPolicy] = useState("");

  const formik = useFormik({
    initialValues: {
      privacyPolicy: "",
    },
    onSubmit: (values) => {
      const { privacyPolicy } = values;
      if (!privacyPolicy) return;

      const payload = {
        email: admin?.email,
        ...helpcenter,
        privacyPolicy,
      };

      if (helpcenter?.privacyPolicy) {
        dispatch(updateHelpCenter(payload));
      } else {
        dispatch(addHelpCenter(payload));
      }
      formik.resetForm();
    },
    validationSchema: Yup.object().shape({}),
  });

  useEffect(() => {
    if (!Object.keys(helpcenter).length) {
      dispatch(getHelpCenter());
    }
  }, [dispatch, helpcenter]);

  useEffect(() => {
    if (helpcenter.privacyPolicy) {
      formik.setFieldValue("privacyPolicy", helpcenter.privacyPolicy);
      setOriginalPrivacyPolicy(helpcenter.privacyPolicy);
    }
  }, [helpcenter]);

  return (
    <>
      <PrivacyScreen
        handleValue={formik.values}
        handleSubmit={formik.handleSubmit}
        handleChange={formik.handleChange}
        originalValue={originalPrivacyPolicy}
      />
      <ToastContainer />
    </>
  );
};

export default PrivacyPolicy;
