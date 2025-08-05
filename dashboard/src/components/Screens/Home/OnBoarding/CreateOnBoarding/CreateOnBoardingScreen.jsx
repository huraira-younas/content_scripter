import { useSelector } from "react-redux";
import { Fragment, useState } from "react";
import Pageheader from "../../../../pageheader/pageheader";
import { compareObjects } from "../../../../../utils/utils";
import Checkbox from "../../../../common/Checkbox/Checkbox";
import Smloader from "../../../../common/smloader/smloader";
import { Button, Card, Col, Form, Row } from "react-bootstrap";
import image18 from "../../../../../assets/images/nft-images/18.png";
import { selectUpdateOnboardingLoader } from "../../../../../pages/selectors";

const CreateOnBoardingScreen = ({
  handleFileChange,
  initialValues,
  handleChange,
  handleSubmit,
  handleValue,
  getLoader,
  touched,
  errors,
  file,
  id,
}) => {
  const [imgLoader, setImgLoader] = useState(false);
  const loader = useSelector(selectUpdateOnboardingLoader);

  const isEqual =
    initialValues &&
    compareObjects(initialValues, handleValue, ["imageUrl"]) &&
    !file;

  const handleButtonClick = () => {
    setImgLoader(true);
    handleSubmit();
  };
  return (
    <Fragment>
      <Pageheader
        title={`${(id && "Update") || "Manage"} OnBoarding`}
        heading={"Onboarding"}
        active={`${(id && "Update") || "Manage"} OnBoarding`}
      />
      <Row>
        <Col xxl={9} xl={8}>
          <Card className="custom-card upload-nft">
            <Card.Header>
              <Card.Title>
                {id ? "You Can Update OnBoarding" : "You Can Create OnBoarding"}
              </Card.Title>
            </Card.Header>
            {getLoader && id ? (
              <div className="mt-5 mb-5 pt-5 pb-5 d-flex justify-content-center text-center align-items-center">
                <Smloader />
              </div>
            ) : (
              <Card.Body>
                <div className="row gy-3 justify-content-between">
                  <Col xxl={12} xl={8} lg={6} md={6} sm={12}>
                    <Form.Label htmlFor="input-file">Upload Image</Form.Label>
                    <Form.Control
                      type="file"
                      id="imageUrl"
                      name="imageUrl"
                      onChange={handleFileChange}
                    />
                    {errors.imageUrl && touched.imageUrl && (
                      <div className="text-danger mt-1">{errors.imageUrl}</div>
                    )}
                  </Col>
                  <Col xxl={8} xl={12}>
                    <div className="row gy-3">
                      <Col xl={6}>
                        <Form.Label
                          htmlFor="input-placeholder"
                          className="form-label"
                        >
                          Title
                        </Form.Label>
                        <Form.Control
                          type="text"
                          id="title"
                          name="title"
                          placeholder="Enter Title"
                          onChange={handleChange}
                          value={handleValue.title}
                        />
                        {errors.title && touched.title && (
                          <div className="text-danger mt-1">{errors.title}</div>
                        )}
                      </Col>
                      <Col xl={6}>
                        <Form.Label
                          htmlFor="input-placeholder"
                          className="form-label"
                        >
                          Page No
                        </Form.Label>
                        <Form.Control
                          id="index"
                          name="index"
                          type="text"
                          onChange={handleChange}
                          value={handleValue.index}
                          placeholder="Enter Index Here"
                        />
                        {errors.index && touched.index && (
                          <div className="text-danger mt-1">{errors.index}</div>
                        )}
                      </Col>
                      <Col xl={12}>
                        <Form.Label
                          className="form-label"
                          htmlFor="nft-description"
                        >
                          Description
                        </Form.Label>
                        <Form.Control
                          rows={4}
                          as="textarea"
                          id="description"
                          name="description"
                          onChange={handleChange}
                          value={handleValue.description}
                          placeholder="Enter Description here"
                        />
                        {errors.description && touched.description && (
                          <div className="text-danger mt-1">
                            {errors.description}
                          </div>
                        )}
                      </Col>
                    </div>
                  </Col>
                </div>
              </Card.Body>
            )}
            <Card.Footer className="text-end">
              <Button
                type="submit"
                onClick={handleButtonClick}
                className="btn btn-primary btn-wave waves-effect waves-light"
                disabled={isEqual || getLoader || loader}
              >
                {loader ? (
                  <Smloader size={"spinner-border-sm "} />
                ) : id ? (
                  "Save"
                ) : (
                  "Create"
                )}
              </Button>
            </Card.Footer>
          </Card>
        </Col>
        <Col xxl={3} xl={4}>
          <Card className="custom-card">
            <Card.Header>
              <Card.Title>OnBoarding Preview</Card.Title>
            </Card.Header>
            <Card.Body>
              <Card className="custom-card mb-0 shadow-none border">
                <img
                  width={20}
                  src={
                    (file && URL.createObjectURL(file)) ||
                    handleValue.imageUrl ||
                    image18
                  }
                  className="card-img-top"
                  alt="..."
                  loading="lazy"
                />

                <Card className="custom-card">
                  <Card.Body>
                    <div className="text-center">
                      <p className={`fw-bold text-truncate text-center`}>
                        {handleValue.title || "Title"}
                      </p>
                    </div>
                    <p className="mb-2">
                      {handleValue.description || "description"}
                    </p>
                  </Card.Body>
                </Card>
              </Card>
            </Card.Body>
          </Card>
        </Col>
      </Row>
    </Fragment>
  );
};

export default CreateOnBoardingScreen;
