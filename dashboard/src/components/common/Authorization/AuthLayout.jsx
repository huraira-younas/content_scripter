import { useEffect, useState } from "react";
import { useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import Loader from "../loader/loader";

const AuthLayout = ({ children, authentication = true }) => {
  const navigate = useNavigate();
  const [loader, setLoader] = useState(true);
  const authStatus = useSelector((state) => state.authStatus);

  useEffect(() => {
    if (authentication && authStatus !== authentication) {
      navigate("/dashboard/login");
    } else if (!authentication && authStatus !== authentication) {
      navigate("/dashboard/users/list");
    }
    setLoader(false);
  }, [authStatus, navigate, authentication]);

  return loader ? (
    <>
      <Loader />
    </>
  ) : (
    <>{children}</>
  );
};

export default AuthLayout;
