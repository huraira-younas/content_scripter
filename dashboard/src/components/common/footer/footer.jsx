import { Fragment } from "react";
import { Link } from "react-router-dom";

const Footer = () => {
  return (
    <Fragment>
      <footer className="footer mt-auto py-3 bg-white text-center">
        <div className="container">
          <span className="text-muted">
            {" "}
            Copyright © 2024 <span id="year"></span>{" "}
            <Link to="/" className="fw-semibold">
              Content Scripter
            </Link>
            . All rights reserved
          </span>
        </div>
      </footer>
    </Fragment>
  );
};

export default Footer;
