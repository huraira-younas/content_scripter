import * as Yup from "yup";
import { useFormik } from "formik";
import { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { selectAdmin, selectHelpCenter } from "../../../selectors";
import {
  addHelpCenter,
  getHelpCenter,
  updateHelpCenter,
} from "../../../../redux/setting/action";
import TermsScreen from "../../../../components/Screens/Home/Setting/Terms/TermsScreen";
import { ToastContainer } from "react-toastify";

const Terms = () => {
  const admin = useSelector(selectAdmin);
  const helpcenter = useSelector(selectHelpCenter);
  const [originalPrivacyPolicy, setOriginalPrivacyPolicy] = useState("");
  const dispatch = useDispatch();

  const formik = useFormik({
    initialValues: {
      termAndServices: "",
    },
    onSubmit: (values) => {
      const { termAndServices } = values;
      if (!termAndServices) return;

      const payload = {
        email: admin?.email,
        ...helpcenter,
        termAndServices,
      };

      if (helpcenter.termAndServices) {
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
    if (helpcenter.termAndServices) {
      formik.setFieldValue("termAndServices", helpcenter.termAndServices);
      setOriginalPrivacyPolicy(helpcenter.termAndServices);
    }
  }, [helpcenter]);

  return (
    <>
      <TermsScreen
        handleValue={formik.values}
        handleSubmit={formik.handleSubmit}
        handleChange={formik.handleChange}
        originalValue={originalPrivacyPolicy}
      />
      <ToastContainer />
    </>
  );
};

export default Terms;
