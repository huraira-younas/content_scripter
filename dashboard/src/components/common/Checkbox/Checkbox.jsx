import React, { useState } from "react";

const Checkbox = ({ title, name, onChange, value }) => {
  // const [select, setSelect] = useState(value);

  // const handleChange = (e) => {
  //   setSelect(e.target.value);
  //   onChange(e);
  // };
  // console.log(name, value);
  return (
    <>
      <div className="">
        <span className="fw-semibold">{title}</span>
      </div>
      <div className="mt-2">
        <div
          className="btn-group"
          role="group"
          aria-label="Basic radio toggle button group"
        >
          <input
            type="radio"
            className="btn-check"
            name={name}
            id={`${name}-enable`}
            value={"true"}
            onChange={onChange}
            checked={value === "true"}
          />
          <label
            className="btn btn-sm btn-outline-primary"
            htmlFor={`${name}-enable`}
          >
            Enable
          </label>
          <input
            type="radio"
            className="btn-check"
            name={name}
            id={`${name}-disable`}
            value={"false"}
            onChange={onChange}
            checked={value === "false"}
          />
          <label
            className="btn btn-sm btn-outline-primary"
            htmlFor={`${name}-disable`}
          >
            Disable
          </label>
        </div>
      </div>
    </>
  );
};

export default Checkbox;
