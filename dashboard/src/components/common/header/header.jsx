import { Fragment, useEffect, useState } from "react";
import {
  Alert,
  Button,
  ButtonGroup,
  Dropdown,
  Form,
  Modal,
} from "react-bootstrap";
import { Link } from "react-router-dom";
import { connect, useSelector } from "react-redux";
import { ThemeChanger } from "../../../redux/theme/action";
import desktopwhite from "../../../assets/images/brand-logos/logo.png";
import desktoplogo from "../../../assets/images/brand-logos/logo.png";
import desktopdark from "../../../assets/images/brand-logos/logo.png";
import togglewhite from "../../../assets/images/brand-logos/logo.png";
import togglelogo from "../../../assets/images/brand-logos/logo.png";
import toggledark from "../../../assets/images/brand-logos/logo.png";
import store from "../../../redux/store";

const Header = ({ local_varaiable, ThemeChanger, logout }) => {
  const admin = useSelector((state) => state.admin);
  const [showa1, setShowa1] = useState(true);
  const toggleShowa1 = () => setShowa1(!showa1);

  const [showa2, setShowa2] = useState(true);
  const toggleShowa2 = () => setShowa2(!showa2);

  const [showa3, setShowa3] = useState(true);
  const toggleShowa3 = () => setShowa3(!showa3);

  // for search modal
  const [show, setShow] = useState(false);

  const handleClose = () => setShow(false);
  const handleShow = () => setShow(true);
  ///****fullscreeen */
  const [fullScreen, setFullScreen] = useState(false);

  const toggleFullScreen = () => {
    const elem = document.documentElement;

    if (!document.fullscreenElement) {
      elem.requestFullscreen().then(() => setFullScreen(true));
    } else {
      document.exitFullscreen().then(() => setFullScreen(false));
    }
  };

  const handleFullscreenChange = () => {
    setFullScreen(!!document.fullscreenElement);
  };

  useEffect(() => {
    document.addEventListener("fullscreenchange", handleFullscreenChange);

    return () => {
      document.removeEventListener("fullscreenchange", handleFullscreenChange);
    };
  }, []);
  ////

  const Switchericon = () => {
    document.querySelector(".offcanvas-end")?.classList.toggle("show");
    const Rightside = document.querySelector(".offcanvas-end");
    Rightside.style.insetInlineEnd = "0px";
    if (
      document.querySelector(".switcher-backdrop")?.classList.contains("d-none")
    ) {
      document.querySelector(".switcher-backdrop")?.classList.add("d-block");
      document.querySelector(".switcher-backdrop")?.classList.remove("d-none");
    }
  };

  //Dark Model
  const ToggleDark = () => {
    ThemeChanger({
      ...local_varaiable,
      dataThemeMode: local_varaiable.dataThemeMode == "dark" ? "light" : "dark",
      dataHeaderStyles:
        local_varaiable.dataThemeMode == "dark" ? "light" : "dark",
      dataMenuStyles:
        local_varaiable.dataNavLayout == "horizontal"
          ? local_varaiable.dataThemeMode == "dark"
            ? "light"
            : "dark"
          : "dark",
    });
    const theme = store.getState();

    if (theme.dataThemeMode != "dark") {
      ThemeChanger({
        ...theme,
        bodyBg1: "",
        bodyBg2: "",
        darkBg: "",
        inputBorder: "",
      });
      localStorage.removeItem("ynexdarktheme");
      localStorage.removeItem("darkBgRGB1");
      localStorage.removeItem("darkBgRGB2");
      localStorage.removeItem("darkBgRGB3");
      localStorage.removeItem("darkBgRGB4");
      localStorage.removeItem("ynexMenu");
      localStorage.removeItem("ynexHeader");
    } else {
      localStorage.setItem("ynexdarktheme", "dark");
      localStorage.removeItem("ynexlighttheme");
      localStorage.removeItem("ynexHeader");
      localStorage.removeItem("ynexMenu");
    }
  };

  function menuClose() {
    const theme = store.getState();
    ThemeChanger({ ...theme, toggled: "close" });
  }

  const toggleSidebar = () => {
    const theme = store.getState();
    const sidemenuType = theme.dataNavLayout;
    if (window.innerWidth >= 992) {
      if (sidemenuType === "vertical") {
        const verticalStyle = theme.dataVerticalStyle;
        const navStyle = theme.dataNavStyle;
        switch (verticalStyle) {
          // closed
          case "closed":
            ThemeChanger({ ...theme, dataNavStyle: "" });
            if (theme.toggled === "close-menu-close") {
              ThemeChanger({ ...theme, toggled: "" });
            } else {
              ThemeChanger({ ...theme, toggled: "close-menu-close" });
            }
            break;
          // icon-overlay
          case "overlay":
            ThemeChanger({ ...theme, dataNavStyle: "" });
            if (theme.toggled === "icon-overlay-close") {
              ThemeChanger({ ...theme, toggled: "" });
            } else {
              if (window.innerWidth >= 992) {
                ThemeChanger({ ...theme, toggled: "icon-overlay-close" });
              }
            }
            break;
          // icon-text
          case "icontext":
            ThemeChanger({ ...theme, dataNavStyle: "" });
            if (theme.toggled === "icon-text-close") {
              ThemeChanger({ ...theme, toggled: "" });
            } else {
              ThemeChanger({ ...theme, toggled: "icon-text-close" });
            }
            break;
          // doublemenu
          case "doublemenu":
            ThemeChanger({ ...theme, dataNavStyle: "" });
            if (theme.toggled === "double-menu-open") {
              ThemeChanger({ ...theme, toggled: "double-menu-close" });
            } else {
              const sidemenu = document.querySelector(
                ".side-menu__item.active"
              );
              if (sidemenu) {
                if (sidemenu.nextElementSibling) {
                  sidemenu.nextElementSibling.classList.add(
                    "double-menu-active"
                  );
                  ThemeChanger({ ...theme, toggled: "double-menu-open" });
                } else {
                  ThemeChanger({ ...theme, toggled: "double-menu-close" });
                }
              }
            }

            break;
          // detached
          case "detached":
            if (theme.toggled === "detached-close") {
              ThemeChanger({ ...theme, toggled: "" });
            } else {
              ThemeChanger({ ...theme, toggled: "detached-close" });
            }
            break;
          // default
          case "default":
            ThemeChanger({ ...theme, toggled: "" });
        }
        switch (navStyle) {
          case "menu-click":
            if (theme.toggled === "menu-click-closed") {
              ThemeChanger({ ...theme, toggled: "" });
            } else {
              ThemeChanger({ ...theme, toggled: "menu-click-closed" });
            }
            break;
          // icon-overlay
          case "menu-hover":
            if (theme.toggled === "menu-hover-closed") {
              ThemeChanger({ ...theme, toggled: "" });
            } else {
              ThemeChanger({ ...theme, toggled: "menu-hover-closed" });
            }
            break;
          case "icon-click":
            if (theme.toggled === "icon-click-closed") {
              ThemeChanger({ ...theme, toggled: "" });
            } else {
              ThemeChanger({ ...theme, toggled: "icon-click-closed" });
            }
            break;
          case "icon-hover":
            if (theme.toggled === "icon-hover-closed") {
              ThemeChanger({ ...theme, toggled: "" });
            } else {
              ThemeChanger({ ...theme, toggled: "icon-hover-closed" });
            }
            break;
        }
      }
    } else {
      if (theme.toggled === "close") {
        ThemeChanger({ ...theme, toggled: "open" });

        setTimeout(() => {
          if (theme.toggled == "open") {
            const overlay = document.querySelector("#responsive-overlay");

            if (overlay) {
              overlay.classList.add("active");
              overlay.addEventListener("click", () => {
                const overlay = document.querySelector("#responsive-overlay");

                if (overlay) {
                  overlay.classList.remove("active");
                  menuClose();
                }
              });
            }
          }

          window.addEventListener("resize", () => {
            if (window.screen.width >= 992) {
              const overlay = document.querySelector("#responsive-overlay");

              if (overlay) {
                overlay.classList.remove("active");
              }
            }
          });
        }, 100);
      } else {
        ThemeChanger({ ...theme, toggled: "close" });
      }
    }
  };

  return (
    <Fragment>
      <header className="app-header">
        <div className="main-header-container container-fluid">
          <div className="header-content-left">
            <div className="header-element">
              <div className="horizontal-logo">
                <Link to={`/dashboard/`} className="header-logo">
                  <img src={desktoplogo} alt="logo" className="desktop-logo" />
                  <img src={desktopdark} alt="logo" className="desktop-dark" />
                  <img src={togglelogo} alt="logo" className="toggle-logo" />
                  <img src={toggledark} alt="logo" className="toggle-dark" />
                  <img
                    className="desktop-white"
                    src={desktopwhite}
                    alt="logo"
                  />
                  <img src={togglewhite} alt="logo" className="toggle-white" />
                </Link>
              </div>
            </div>
            <div className="header-element">
              <Link
                aria-label="Hide Sidebar"
                onClick={() => toggleSidebar()}
                className="sidemenu-toggle header-link animated-arrow hor-toggle horizontal-navtoggle"
                data-bs-toggle="sidebar"
                to="#"
              >
                <span></span>
              </Link>
            </div>
          </div>

          <div className="header-content-right">
            <div className="header-element header-theme-mode">
              <Link
                to="#"
                className="header-link layout-setting"
                onClick={() => ToggleDark()}
              >
                <span className="light-layout">
                  <i className="bx bx-moon header-link-icon"></i>
                </span>
                <span className="dark-layout">
                  <i className="bx bx-sun header-link-icon"></i>
                </span>
              </Link>
            </div>
            <div className="header-element header-fullscreen">
              <Link onClick={toggleFullScreen} to="#" className="header-link">
                {fullScreen ? (
                  <i className="bx bx-exit-fullscreen header-link-icon"></i>
                ) : (
                  <i className="bx bx-fullscreen header-link-icon"></i>
                )}
              </Link>
            </div>
            <Dropdown className="header-element header-profile">
              <Dropdown.Toggle
                variant=""
                className="header-link"
                id="mainHeaderProfile"
                data-bs-toggle="dropdown"
                data-bs-auto-close="outside"
                aria-expanded="false"
              >
                <div className="d-flex align-items-center">
                  <div className="me-sm-2 me-0">
                    <img
                      src={admin?.profileUrl}
                      alt="img"
                      width="32"
                      height="32"
                      className="rounded-circle"
                    />
                  </div>
                  <div className="d-sm-block d-none">
                    <p className="fw-semibold mb-0 lh-1 fs-13">{admin?.name}</p>
                    <span className="op-7 fw-normal d-block fs-11">
                      Developer
                    </span>
                  </div>
                </div>
              </Dropdown.Toggle>
              <Dropdown.Menu
                align="end"
                as="ul"
                className="main-header-dropdown dropdown-menu pt-0 overflow-hidden header-profile-dropdown dropdown-menu-end"
                aria-labelledby="mainHeaderProfile"
              >
                <Dropdown.Item
                  className="d-flex"
                  href="#"
                  onClick={() => logout()}
                >
                  <i className="ti ti-logout fs-18 me-2 op-7"></i>Log Out
                </Dropdown.Item>
              </Dropdown.Menu>
            </Dropdown>
            <div className="header-element">
              <Link
                to="#"
                className="header-link switcher-icon"
                data-bs-toggle="offcanvas"
                data-bs-target="#switcher-canvas"
                onClick={() => Switchericon()}
              >
                <i className="bx bx-cog header-link-icon"></i>
              </Link>
            </div>
          </div>
        </div>
      </header>
      <Modal
        className="modal fade"
        id="searchModal"
        tabIndex={-1}
        aria-labelledby="searchModal"
        aria-hidden="true"
        show={show}
        onHide={handleClose}
      >
        <Modal.Body>
          <div className="input-group">
            <Link to="#" className="input-group-text" id="Search-Grid">
              <i className="fe fe-search header-link-icon fs-18"></i>
            </Link>
            <Form.Control
              type="search"
              className="form-control border-0 px-2"
              placeholder="Search"
              aria-label="Username"
              autoComplete="off"
            />

            <Link to="#" className="input-group-text" id="voice-search">
              <i className="fe fe-mic header-link-icon"></i>
            </Link>
            <Dropdown>
              <Dropdown.Toggle
                variant=""
                href="#"
                className="btn btn-light btn-icon no-caret"
                data-bs-toggle="dropdown"
                aria-expanded="false"
              >
                <i className="fe fe-more-vertical"></i>
              </Dropdown.Toggle>
              <Dropdown.Menu className="dropdown-menu" as="ul">
                <Dropdown.Item as="li" className="dropdown-item" href="#">
                  Action
                </Dropdown.Item>
                <Dropdown.Item as="li" className="dropdown-item" href="#">
                  Another action
                </Dropdown.Item>
                <Dropdown.Item as="li" className="dropdown-item" href="#">
                  Something else here
                </Dropdown.Item>
                <Dropdown.Divider as="li">
                  <hr className="dropdown-divider" />
                </Dropdown.Divider>
                <Dropdown.Item as="li" className="dropdown-item" href="#">
                  Separated link
                </Dropdown.Item>
              </Dropdown.Menu>
            </Dropdown>
          </div>
          <div className="mt-4">
            <p className="font-weight-semibold text-muted mb-2">
              Are You Looking For...
            </p>
            <span className="search-tags">
              <i className="fe fe-user me-2"></i>People
              <Link to="#" className="tag-addon">
                <i className="fe fe-x"></i>
              </Link>
            </span>
            <span className="search-tags">
              <i className="fe fe-file-text me-2"></i>Pages
              <Link to="#" className="tag-addon">
                <i className="fe fe-x"></i>
              </Link>
            </span>
            <span className="search-tags">
              <i className="fe fe-align-left me-2"></i>Articles
              <Link to="#" className="tag-addon">
                <i className="fe fe-x"></i>
              </Link>
            </span>
            <span className="search-tags">
              <i className="fe fe-server me-2"></i>Tags
              <Link to="#" className="tag-addon">
                <i className="fe fe-x"></i>
              </Link>
            </span>
          </div>
          <div className="my-4">
            <p className="font-weight-semibold text-muted mb-2">
              Recent Search :
            </p>
            <Alert
              variant=""
              className="p-2 border br-5 d-flex align-items-center text-muted mb-2 alert"
              show={showa1}
            >
              <Link to="#">
                <span>Notifications</span>
              </Link>
              <Link
                className="ms-auto lh-1"
                to="#"
                data-bs-dismiss="alert"
                aria-label="Close"
                onClick={toggleShowa1}
              >
                <i className="fe fe-x text-muted"></i>
              </Link>
            </Alert>
            <Alert
              variant=""
              className="p-2 border br-5 d-flex align-items-center text-muted mb-2 alert"
              show={showa2}
            >
              <Link to="#">
                <span>Alerts</span>
              </Link>
              <Link
                className="ms-auto lh-1"
                to="#"
                data-bs-dismiss="alert"
                aria-label="Close"
                onClick={toggleShowa2}
              >
                <i className="fe fe-x text-muted"></i>
              </Link>
            </Alert>
            <Alert
              variant=""
              className="p-2 border br-5 d-flex align-items-center text-muted mb-0 alert"
              show={showa3}
            >
              <Link to="#">
                <span>Mail</span>
              </Link>
              <Link
                className="ms-auto lh-1"
                to="#"
                data-bs-dismiss="alert"
                aria-label="Close"
                onClick={toggleShowa3}
              >
                <i className="fe fe-x text-muted"></i>
              </Link>
            </Alert>
          </div>
        </Modal.Body>
        <Modal.Footer>
          <ButtonGroup className="btn-group ms-auto">
            <Button variant="primary-light" className="btn btn-sm">
              Search
            </Button>
            <Button variant="primary" className="btn btn-sm -">
              Clear Recents
            </Button>
          </ButtonGroup>
        </Modal.Footer>
      </Modal>
    </Fragment>
  );
};

const mapStateToProps = (state) => ({
  local_varaiable: state,
});
export default connect(mapStateToProps, { ThemeChanger })(Header);
