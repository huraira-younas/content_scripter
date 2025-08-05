import React from "react";

const Smloader = ({ size }) => {
  return (
    <>
      <span
        className={`spinner-border spinner-border-sm align-middle ${size}`}
        role="status"
        aria-hidden="true"
      ></span>
      <span className="visually-hidden">Loading...</span>
    </>
  );
};

export default Smloader;
