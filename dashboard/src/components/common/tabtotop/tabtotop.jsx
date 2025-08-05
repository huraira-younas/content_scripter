import  { useState, useEffect } from "react";

const TabToTop = () => {
  const [BacktoTop, setBacktopTop] = useState("");
  useEffect(() => {
    window.addEventListener("scroll", () => {
      if (window.scrollY > 100) {
        setBacktopTop("d-block");
      } else setBacktopTop("");
    });
  }, []);
  const screenup = () => {
    window.scrollTo({
      top: 10,
      behavior: "auto",
      //   smooth
    });
  };
  return (
    <>
      <div
        id="back-to-top"
        onClick={screenup}
        className={`scrollToTop ${BacktoTop}`}
      >
        <span className="arrow">
<i className="ri-arrow-up-s-fill fs-20 pt-1"></i>
</span>
      </div>
    </>
  );
};

TabToTop.propTypes = {};

TabToTop.defaultProps = {};

export default TabToTop;
