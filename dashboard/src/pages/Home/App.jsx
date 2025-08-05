import Switcher from "../../components/common/switcher/switcher";
import TabToTop from "../../components/common/tabtotop/tabtotop";
import Sidebar from "../../components/common/sidebar/sidebar";
import Header from "../../components/common/header/header";
import Loader from "../../components/common/loader/loader";
import Footer from "../../components/common/footer/footer";
import { logout } from "../../redux/authentication/action";
import { Helmet, HelmetProvider } from "react-helmet-async";
import { Fragment, useEffect, useState } from "react";
import "react-toastify/dist/ReactToastify.css";
import { useDispatch } from "react-redux";
import { Outlet } from "react-router-dom";

function App() {
  const [MyclassName, setMyClass] = useState("");
  const [loader, setLoader] = useState(false);
  const dispatch = useDispatch();

  const Bodyclickk = () => {
    if (localStorage.getItem("ynexverticalstyles") == "icontext") {
      setMyClass("");
    }
  };

  const handleLogout = () => {
    setLoader(true);
    setTimeout(() => {
      dispatch(logout());
      setLoader(false);
    }, 1000);
  };

  const [isLoading, setIsLoading] = useState(
    localStorage.ynexloaderdisable != "disable"
  );

  useEffect(() => {
    setTimeout(() => {
      setIsLoading(false);
    }, 300);
  }, []);

  if (loader) return <Loader />;

  return (
    <Fragment>
      {isLoading && <Loader></Loader>}
      <HelmetProvider>
        <Helmet
          htmlAttributes={{
            "data-vertical-style": "overlay",
            "data-icon-text": MyclassName,
            "data-header-styles": "light",
            "data-nav-layout": "vertical",
            "data-theme-mode": "light",
            "data-menu-styles": "dark",
            "data-loader": "disable",
            lang: "en",
            dir: "ltr",
          }}
        />
        <Switcher />
        <div className="page">
          <Header logout={handleLogout} />
          <Sidebar />
          <div className="main-content app-content" onClick={Bodyclickk}>
            <div className="container-fluid">
              <Outlet />
            </div>
          </div>
          <Footer />
        </div>
        <TabToTop />
      </HelmetProvider>
    </Fragment>
  );
}

export default App;
