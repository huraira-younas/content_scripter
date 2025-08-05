import { Fragment, useState, useEffect, useRef } from "react";
import { Link, useLocation } from "react-router-dom";
import { MENUITEMS } from "./sidemenu/sidemenu";
import logo from "../../../assets/images/brand-logos/logo.png";
import RSC from "react-scrollbars-custom";
import { connect } from "react-redux";
import { ThemeChanger } from "../../../redux/theme/action";
import store from "../../../redux/store";
const history = [];

const Sidebar = ({ local_varaiable, ThemeChanger }) => {
  const location = useLocation();
  const [menuitems, setMenuitems] = useState(MENUITEMS);

  useEffect(() => {
    history.push(location.pathname); // add  history to history  stack for current location.pathname to prevent multiple history calls innerWidth  and innerWidth  calls from  multiple users. This is important because the history stack is not always empty when the user clicks  the history
    if (history.length > 2) {
      history.shift();
    }
    if (history[0] !== history[1]) {
    }
    const mainContent = document.querySelector(".main-content");

    //when we click on the body to remove
    mainContent.addEventListener("click", mainContentClickFn);
    return () => {
      mainContent.removeEventListener("click", mainContentClickFn);
    };
  }, [location, mainContentClickFn]);

  // location
  useEffect(() => {
    if (
      document.body.classList.contains("horizontal") &&
      window.innerWidth >= 992
    ) {
      clearMenuActive();
    }
  }, []);
  //  In Horizontal When we click the body it should we Closed using in useEfffect Refer line No:16
  function mainContentClickFn() {
    if (
      document.body.classList.contains("horizontal") &&
      window.innerWidth >= 992
    ) {
      clearMenuActive();
    }
  }

  function clearMenuActive() {
    MENUITEMS.filter((mainlevel) => {
      if (mainlevel.Items) {
        mainlevel.Items.map((sublevel) => {
          sublevel.active = false;
          if (sublevel.children) {
            sublevel.children.map((sublevel1) => {
              sublevel1.active = false;
              if (sublevel1.children) {
                sublevel1.children.map((sublevel2) => {
                  sublevel2.active = false;
                  return sublevel2;
                });
              }
              return sublevel1;
            });
          }
          return sublevel;
        });
      }
      return mainlevel;
    });
    setMenuitems((arr) => [...arr]);
  }

  function toggleSidemenu(item) {
    if (
      !document.body.classList.contains("horizontal-hover") ||
      window.innerWidth < 992
    ) {
      if (!item.active) {
        MENUITEMS.map((mainlevel) => {
          if (mainlevel.Items) {
            mainlevel.Items.map((sublevel) => {
              sublevel.active = false;
              if (item === sublevel) {
                sublevel.active = true;
              }
              if (sublevel.children) {
                sublevel.children.map((sublevel1) => {
                  sublevel1.active = false;
                  if (item === sublevel1) {
                    sublevel.active = true;
                    sublevel1.active = true;
                  }
                  if (sublevel1.children) {
                    sublevel1.children.map((sublevel2) => {
                      sublevel2.active = false;
                      if (item === sublevel2) {
                        sublevel.active = true;
                        sublevel1.active = true;
                        sublevel2.active = true;
                      }
                      if (sublevel2.children) {
                        sublevel2.children.map((sublevel3) => {
                          sublevel3.active = false;
                          if (item === sublevel3) {
                            sublevel.active = true;
                            sublevel1.active = true;
                            sublevel2.active = true;
                            sublevel3.active = true;
                          }
                          return sublevel2;
                        });
                      }
                      return sublevel2;
                    });
                  }
                  return sublevel1;
                });
              }
              return sublevel;
            });
          }
          return mainlevel;
        });
      } else {
        if (localStorage.ynexverticalstyles != "doublemenu") {
          item.active = !item.active;
        }
      }
    }

    const theme = store.getState();
    if (
      localStorage.ynexverticalstyles === "doublemenu" &&
      theme.toggled !== "double-menu-open"
    ) {
      // if (!document.querySelectorAll(".main-menu .slide.active")[0].querySelector('ul')) {
      ThemeChanger({ ...theme, toggled: "double-menu-open" });
      // }
    }
    setMenuitems((arr) => [...arr]);
  }

  function Onhover() {
    const theme = store.getState();
    if (
      (theme.toggled == "icon-overlay-close" ||
        theme.toggled == "detached-close") &&
      theme.iconOverlay != "open"
    ) {
      ThemeChanger({ ...theme, iconOverlay: "open" });
    }
  }
  function Outhover() {
    const theme = store.getState();
    if (
      (theme.toggled == "icon-overlay-close" ||
        theme.toggled == "detached-close") &&
      theme.iconOverlay == "open"
    ) {
      ThemeChanger({ ...theme, iconOverlay: "" });
    }
  }
  function Clickhandelar() {
    if (localStorage.getItem("ynexverticalstyles") == "icontext") {
      ThemeChanger({ ...local_varaiable, iconText: "open" });
    }
  }
  function menuClose() {
    const theme = store.getState();
    if (window.innerWidth <= 992) {
      ThemeChanger({ ...theme, toggled: "close" });
    }
    const overlayElement = document.querySelector("#responsive-overlay");
    if (overlayElement) {
      overlayElement.classList.remove("active");
    }
  }

  useEffect(() => {
    const mainContent = document.querySelector(".main-content");
    if (window.innerWidth <= 992) {
      if (mainContent) {
        mainContent.addEventListener("click", menuClose);
        menuClose();
      }
    } else {
      if (mainContent) {
        mainContent.removeEventListener("click", menuClose);
      }
    }
    window.addEventListener("resize", () => {
      const mainContent = document.querySelector(".main-content");
      setTimeout(() => {
        if (window.innerWidth <= 992) {
          if (mainContent) {
            mainContent.addEventListener("click", menuClose);
            menuClose();
          }
        } else {
          if (mainContent) {
            mainContent.removeEventListener("click", menuClose);
          }
        }
      }, 100);
    });
  }, []);

  function setSidemenu(list) {
    let dd = list ? list.path : location.pathname;
    if (menuitems) {
      menuitems.filter((mainlevel) => {
        if (mainlevel.Items) {
          mainlevel.Items.filter((items) => {
            if (ulRef.current) {
              if (
                ulRef.current.href != document.location.href ||
                localStorage.ynexverticalstyles != "doublemenu"
              ) {
                items.active = false;
              }
            }
            items.selected = false;

            if (dd === "/") {
              dd = "/dashboards/crm/";
            }
            if (dd === items.path) {
              items.active = true;
              items.selected = true;
            }

            if (items.children) {
              items.children.filter((submenu) => {
                submenu.active = false;
                submenu.selected = false;
                if (dd === submenu.path) {
                  const theme = store.getState();
                  items.active =
                    theme.dataNavLayout == "horizontal" ||
                    theme.dataNavStyle == "icon-hover"
                      ? false
                      : true;
                  items.selected = true;
                  submenu.active = true;
                  submenu.selected = true;
                }
                if (submenu.path === "#") {
                  submenu.active = false;
                  submenu.selected = false;
                }
                if (submenu.children) {
                  submenu.children.filter((submenu1) => {
                    submenu1.active = false;
                    submenu1.selected = false;
                    if (dd === submenu1.path) {
                      items.active = true;
                      items.selected = true;
                      submenu.active = true;
                      submenu.selected = true;
                      submenu1.active = true;
                      submenu1.selected = true;
                    }
                    if (submenu1.path === "#") {
                      submenu1.active = false;
                      submenu1.selected = false;
                    }
                    return submenu1;
                  });
                }
                return submenu;
              });
            }
            return items;
          });
        }
        setMenuitems((arr) => [...arr]);
        return mainlevel;
      });
    }

    if (localStorage.getItem("ynexverticalstyles") == "icontext") {
    }
    if (local_varaiable.dataVerticalStyle == "doublemenu") {
    }
  }

  function switcherArrowFn() {
    // Used to remove is-expanded class and remove class on clicking arrow buttons
    function slideClick() {
      const slide = document.querySelectorAll(".slide");
      const slideMenu = document.querySelectorAll(".slide-menu");

      slide.forEach((element) => {
        if (element.classList.contains("is-expanded")) {
          element.classList.remove("is-expanded");
        }
      });

      slideMenu.forEach((element) => {
        if (element.classList.contains("open")) {
          element.classList.remove("open");
          element.style.display = "none";
        }
      });
    }

    slideClick();
  }

  function slideRight() {
    const menuNav = document.querySelector(".main-menu");
    const mainContainer1 = document.querySelector(".main-sidebar");

    if (menuNav && mainContainer1) {
      const marginLeftValue = Math.ceil(
        window.getComputedStyle(menuNav).marginInlineStart.split("px")[0]
      );
      const marginRightValue = Math.ceil(
        window.getComputedStyle(menuNav).marginInlineEnd.split("px")[0]
      );
      const check = menuNav.scrollWidth - mainContainer1.offsetWidth;
      let mainContainer1Width = mainContainer1.offsetWidth;

      if (menuNav.scrollWidth > mainContainer1.offsetWidth) {
        if (!(local_varaiable.dataVerticalStyle.dir === "rtl")) {
          if (Math.abs(check) > Math.abs(marginLeftValue)) {
            menuNav.style.marginInlineEnd = "0";

            if (
              !(
                Math.abs(check) >
                Math.abs(marginLeftValue) + mainContainer1Width
              )
            ) {
              mainContainer1Width = Math.abs(check) - Math.abs(marginLeftValue);
              const slideRightButton = document.querySelector("#slide-right");
              if (slideRightButton) {
                slideRightButton.classList.add("hidden");
              }
            }

            menuNav.style.marginInlineStart =
              menuNav.style.marginInlineStart.split("px")[0] -
              Math.abs(mainContainer1Width) +
              "px";

            const slideRightButton = document.querySelector("#slide-right");
            if (slideRightButton) {
              slideRightButton.classList.remove("hidden");
            }
          }
        } else {
          if (Math.abs(check) > Math.abs(marginRightValue)) {
            menuNav.style.marginInlineStart = "0";

            if (
              !(
                Math.abs(check) >
                Math.abs(marginRightValue) + mainContainer1Width
              )
            ) {
              mainContainer1Width =
                Math.abs(check) - Math.abs(marginRightValue);
              const slideRightButton = document.querySelector("#slide-right");
              if (slideRightButton) {
                slideRightButton.classList.add("hidden");
              }
            }

            menuNav.style.marginInlineEnd =
              menuNav.style.marginInlineEnd.split("px")[0] -
              Math.abs(mainContainer1Width) +
              "px";

            const slideLeftButton = document.querySelector("#slide-left");
            if (slideLeftButton) {
              slideLeftButton.classList.remove("hidden");
            }
          }
        }
      }

      const element = document.querySelector(".main-menu > .slide.open");
      const element1 = document.querySelector(".main-menu > .slide.open > ul");
      if (element) {
        element.classList.remove("active");
      }
      if (element1) {
        element1.style.display = "none";
      }
    }

    switcherArrowFn();
  }

  function slideLeft() {
    const menuNav = document.querySelector(".main-menu");
    const mainContainer1 = document.querySelector(".main-sidebar");

    if (menuNav && mainContainer1) {
      const marginLeftValue = Math.ceil(
        window.getComputedStyle(menuNav).marginInlineStart.split("px")[0]
      );
      const marginRightValue = Math.ceil(
        window.getComputedStyle(menuNav).marginInlineEnd.split("px")[0]
      );
      const check = menuNav.scrollWidth - mainContainer1.offsetWidth;
      let mainContainer1Width = mainContainer1.offsetWidth;

      if (menuNav.scrollWidth > mainContainer1.offsetWidth) {
        if (!(local_varaiable.dataVerticalStyle.dir === "rtl")) {
          if (Math.abs(check) <= Math.abs(marginLeftValue)) {
            menuNav.style.marginInlineStart = "0px";
          }
        } else {
          if (Math.abs(check) > Math.abs(marginRightValue)) {
            menuNav.style.marginInlineStart = "0";

            if (
              !(
                Math.abs(check) >
                Math.abs(marginRightValue) + mainContainer1Width
              )
            ) {
              mainContainer1Width =
                Math.abs(check) - Math.abs(marginRightValue);
              const slideRightButton = document.querySelector("#slide-right");
              if (slideRightButton) {
                slideRightButton.classList.add("hidden");
              }
            }

            menuNav.style.marginInlineEnd =
              menuNav.style.marginInlineEnd.split("px")[0] -
              Math.abs(mainContainer1Width) +
              "px";

            const slideLeftButton = document.querySelector("#slide-left");
            if (slideLeftButton) {
              slideLeftButton.classList.remove("hidden");
            }
          }
        }
      }

      const element = document.querySelector(".main-menu > .slide.open");
      const element1 = document.querySelector(".main-menu > .slide.open > ul");
      if (element) {
        element.classList.remove("active");
      }
      if (element1) {
        element1.style.display = "none";
      }
    }

    switcherArrowFn();
  }
  const noChild = () => {
    if (localStorage.ynexverticalstyles == "doublemenu") {
      const theme = store.getState();
      ThemeChanger({ ...theme, toggled: "double-menu-close" });
    }
  };

  const ulRef = useRef(null);
  const ulElement = useRef(null);

  useEffect(() => {
    if (
      localStorage.ynexverticalstyles != "overlay" &&
      localStorage.ynexverticalstyles != "detached"
    ) {
      setSidemenu();
    }
  }, []);

  const MenuOpen = (_event) => {
    const MainContent = document.querySelector(".main-content");

    if (
      local_varaiable.dataVerticalStyle === "icontext" &&
      local_varaiable.iconText !== "open"
    ) {
      const theme = store.getState();
      ThemeChanger({ ...theme, iconText: "open" });

      MainContent?.addEventListener("click", (_event) => {
        const theme = store.getState();
        ThemeChanger({ ...theme, iconText: "" });
      });
    }
    const theme = store.getState();
    if (
      localStorage.ynexverticalstyles === "doublemenu" &&
      theme.toggled !== "double-menu-open"
    ) {
      ThemeChanger({ ...theme, toggled: "double-menu-open" });
    }
  };

  return (
    <Fragment>
      <div id="responsive-overlay" onClick={() => menuClose()}></div>
      <aside
        className="app-sidebar sticky"
        id="sidebar"
        onMouseEnter={() => Onhover()}
        onMouseLeave={() => Outhover()}
      >
        <div className="main-sidebar-header">
          <Link to={`/dashboard/`} className="header-logo">
            <img src={logo} alt="logo" className="desktop-logo" />
            <img src={logo} alt="logo" className="toggle-logo" />
            <img src={logo} alt="logo" className="desktop-dark" />
            <img src={logo} alt="logo" className="toggle-dark" />
            <img src={logo} alt="logo" className="desktop-white" />
            <img src={logo} alt="logo" className="toggle-white" />
          </Link>
        </div>

        <div className="main-sidebar" id="sidebar-scroll">
          <RSC style={{ width: "100%", height: "100%" }} noScrollX={false}>
            <nav className="main-menu-container nav nav-pills flex-column sub-open">
              <div className="slide-left" id="slide-left">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="#7b8191"
                  onClick={() => {
                    slideLeft();
                  }}
                  width="24"
                  height="24"
                  viewBox="0 0 24 24"
                >
                  {" "}
                  <path d="M13.293 6.293 7.586 12l5.707 5.707 1.414-1.414L10.414 12l4.293-4.293z"></path>{" "}
                </svg>
              </div>

              <ul className="main-menu" style={{ marginRight: "0px" }}>
                {MENUITEMS.map((levelone) => (
                  <Fragment key={Math.random()}>
                    {levelone.menutitle ? (
                      <li className="slide__category">
                        <span className="category-name">
                          {levelone.menutitle}
                        </span>
                      </li>
                    ) : (
                      ""
                    )}
                    {levelone.Items.map((leveltwo) =>
                      leveltwo.type === "link" ? (
                        <li
                          className={`slide ${leveltwo.active ? "active" : ""}`}
                          key={Math.random()}
                        >
                          <Link
                            ref={ulRef}
                            onClick={(_event) => {
                              setSidemenu(leveltwo);
                              noChild();
                            }}
                            to={leveltwo.path}
                            className={`side-menu__item ${
                              leveltwo.selected ? "active" : ""
                            }`}
                          >
                            {leveltwo.icon}{" "}
                            <span className="side-menu__label">
                              {leveltwo.title}
                              {leveltwo.badgetxt ? (
                                <span className={leveltwo.class}>
                                  {leveltwo.badgetxt}
                                </span>
                              ) : (
                                ""
                              )}
                            </span>
                          </Link>
                        </li>
                      ) : leveltwo.type === "sub" ? (
                        <li
                          className={`slide has-sub ${
                            leveltwo.active ? "open" : ""
                          } ${leveltwo.selected ? "active" : ""} `}
                          // <li className={`slide has-sub ${leveltwo.active ? "active open" : ''}`}
                          key={Math.random()}
                          onClick={(event) => {
                            MenuOpen(event);
                          }}
                        >
                          <a
                            href="#"
                            className={`side-menu__item ${
                              leveltwo.selected ? "active" : ""
                            }`}
                            onClick={(event) => {
                              event.preventDefault();
                              toggleSidemenu(leveltwo);
                            }}
                          >
                            {leveltwo.icon}
                            <span className="side-menu__label">
                              {leveltwo.title}
                              {leveltwo.badgetxt ? (
                                <span className={leveltwo.class}>
                                  {leveltwo.badgetxt}
                                </span>
                              ) : (
                                ""
                              )}
                            </span>
                            <i className="angle fe fe-chevron-right side-menu__angle"></i>
                          </a>
                          <ul
                            ref={ulElement}
                            className={`slide-menu child1 ${
                              leveltwo.active ? "active" : ""
                            } 
                            ${
                              leveltwo.active &&
                              localStorage.ynexverticalstyles == "doublemenu"
                                ? "double-menu-active"
                                : ""
                            }`}
                            style={
                              leveltwo.active
                                ? { display: "block" }
                                : { display: "none" }
                            }
                          >
                            <li className="slide side-menu__label1">
                              <a href="">{leveltwo.title}</a>
                            </li>

                            {leveltwo.children?.map((thirdlayer) => (
                              <Fragment key={Math.random()}>
                                {thirdlayer.type === "link" ? (
                                  <li
                                    className={`slide ${
                                      thirdlayer.active ? "active" : ""
                                    }`}
                                  >
                                    {thirdlayer.path == "/" ? (
                                      <Link
                                        to={"#"}
                                        className={`side-menu__item ${
                                          thirdlayer.selected ? "active" : ""
                                        } ${thirdlayer.active ? "active" : ""}`}
                                      >
                                        {thirdlayer.icon}
                                        {thirdlayer.title}
                                      </Link>
                                    ) : (
                                      <Link
                                        onClick={(_event) => {
                                          setSidemenu(thirdlayer);
                                        }}
                                        to={thirdlayer.path}
                                        className={`side-menu__item ${
                                          thirdlayer.selected ? "active" : ""
                                        } ${thirdlayer.active ? "active" : ""}`}
                                      >
                                        {thirdlayer.icon}
                                        {thirdlayer.title}
                                        <span className={thirdlayer.class}>
                                          {thirdlayer.badgetxt}
                                        </span>
                                      </Link>
                                    )}
                                  </li>
                                ) : thirdlayer.type === "sub" ? (
                                  <li
                                    className={`slide has-sub ${
                                      thirdlayer.active ? "open" : ""
                                    } ${thirdlayer.selected ? "active" : ""}`}
                                  >
                                    <a
                                      href="#"
                                      className={`side-menu__item ${
                                        thirdlayer.selected ? "active" : ""
                                      } `}
                                      onClick={(evnt) => {
                                        evnt.preventDefault();
                                        toggleSidemenu(thirdlayer);
                                        Clickhandelar();
                                      }}
                                    >
                                      {thirdlayer.icon}{" "}
                                      <span className="">
                                        {thirdlayer.title}
                                        {thirdlayer.badgetxt ? (
                                          <span className={thirdlayer.class}>
                                            {thirdlayer.badgetxt}
                                          </span>
                                        ) : (
                                          ""
                                        )}
                                      </span>
                                      <i className="fe fe-chevron-right side-menu__angle"></i>
                                    </a>
                                    <ul
                                      className={`slide-menu child2 ${
                                        thirdlayer.active ? "active" : ""
                                      }`}
                                      style={
                                        thirdlayer.active
                                          ? { display: "block" }
                                          : { display: "none" }
                                      }
                                    >
                                      {thirdlayer.children.map(
                                        (fourthlayer) => (
                                          <Fragment key={Math.random()}>
                                            {fourthlayer.type === "link" ? (
                                              <li
                                                className={`slide ${
                                                  fourthlayer.active
                                                    ? "active"
                                                    : ""
                                                }`}
                                              >
                                                <Link
                                                  onClick={(_event) => {
                                                    setSidemenu(fourthlayer);
                                                  }}
                                                  to={
                                                    fourthlayer.path == "/"
                                                      ? "#"
                                                      : fourthlayer.path
                                                  }
                                                  className={`side-menu__item ${
                                                    fourthlayer.selected
                                                      ? "active"
                                                      : ""
                                                  }`}
                                                >
                                                  {fourthlayer.icon}
                                                  {fourthlayer.title}
                                                </Link>
                                              </li>
                                            ) : fourthlayer.type === "sub" ? (
                                              <li
                                                className={`slide has-sub ${
                                                  fourthlayer.active
                                                    ? "open"
                                                    : ""
                                                }`}
                                              >
                                                <a
                                                  href="#"
                                                  className="side-menu__item"
                                                  onClick={(evnt) => {
                                                    evnt.preventDefault();
                                                    toggleSidemenu(fourthlayer);
                                                  }}
                                                >
                                                  {fourthlayer.icon}{" "}
                                                  <span className="">
                                                    {fourthlayer.title}
                                                  </span>
                                                  <i className="ri ri-arrow-right-s-line side-menu__angle"></i>
                                                </a>
                                              </li>
                                            ) : (
                                              ""
                                            )}
                                          </Fragment>
                                        )
                                      )}
                                    </ul>
                                  </li>
                                ) : (
                                  ""
                                )}
                              </Fragment>
                            ))}
                          </ul>
                        </li>
                      ) : (
                        ""
                      )
                    )}
                  </Fragment>
                ))}
              </ul>

              <div className="slide-right" id="slide-right">
                <svg
                  onClick={() => {
                    slideRight();
                  }}
                  xmlns="http://www.w3.org/2000/svg"
                  fill="#7b8191"
                  width="24"
                  height="24"
                  viewBox="0 0 24 24"
                >
                  {" "}
                  <path d="M10.707 17.707 16.414 12l-5.707-5.707-1.414 1.414L13.586 12l-4.293 4.293z"></path>{" "}
                </svg>
              </div>
            </nav>
          </RSC>
        </div>
      </aside>
    </Fragment>
  );
};
const mapStateToProps = (state) => ({
  local_varaiable: state,
});
export default connect(mapStateToProps, { ThemeChanger })(Sidebar);
