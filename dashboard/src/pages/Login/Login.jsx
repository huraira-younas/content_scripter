import * as Yup from "yup";
import { useFormik } from "formik";
import "react-toastify/dist/ReactToastify.css";
import { ToastContainer } from "react-toastify";
import { selectAuthLoader } from "../selectors";
import { useDispatch, useSelector } from "react-redux";
import { login } from "../../redux/authentication/action";
import LoginScreen from "../../components/Screens/Login/LoginScreen";

const Login = () => {
  const dispatch = useDispatch();
  const authLoader = useSelector(selectAuthLoader);
  const formik = useFormik({
    initialValues: {
      email: "",
      password: "",
      remember: false,
    },
    onSubmit: (values) => {
      dispatch(login(values));
    },
    validationSchema: Yup.object().shape({
      email: Yup.string().email("Invalid email").required("Email is required"),
      password: Yup.string()
        .min(6, "Password is too short")
        .max(20, "Password is too long")
        .required("Password is required"),
    }),
  });

  return (
    <>
      <LoginScreen
        handleSubmit={formik.handleSubmit}
        handleChange={formik.handleChange}
        handleValue={formik.values}
        touched={formik.touched}
        errors={formik.errors}
        loader={authLoader}
      />
      <ToastContainer />
    </>
  );
};

export default Login;
