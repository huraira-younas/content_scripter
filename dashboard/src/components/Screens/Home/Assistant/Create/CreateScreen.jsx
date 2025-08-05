import { useSelector } from "react-redux";
import { Fragment, useState } from "react";
import Pageheader from "../../../../pageheader/pageheader";
import { compareObjects } from "../../../../../utils/utils";
import Checkbox from "../../../../common/Checkbox/Checkbox";
import Smloader from "../../../../common/smloader/smloader";
import { Button, Card, Col, Form, Row } from "react-bootstrap";
import image18 from "../../../../../assets/images/nft-images/18.png";
import {
  selectUpdateAssistantLoader,
  selectUpdateOnboardingLoader,
} from "../../../../../pages/selectors";

const CreateScreen = ({
  handleFileChange,
  initialValues,
  handleChange,
  handleSubmit,
  handleValue,
  getLoader,
  imgLoader,
  touched,
  errors,
  file,
  id,
}) => {
  // const [imgLoader, setImgLoader] = useState(false);
  const loader = useSelector(selectUpdateAssistantLoader);

  const isEqual =
    initialValues &&
    compareObjects(initialValues, handleValue, ["icon"]) &&
    !file;

  const handleButtonClick = () => {
    // setImgLoader(true);
    handleSubmit();
  };
  return (
    <Fragment>
      <Pageheader
        title={`${(id && "Update") || "Create"} Assistant`}
        heading={"Assistant"}
        active={`${(id && "Update") || "Create"} Assistant`}
      />
      <Row>
        <Col xxl={9} xl={8}>
          <Card className="custom-card upload-nft">
            <Card.Header>
              <Card.Title>
                {id ? "You can update assistant" : "You can create assistant"}
              </Card.Title>
            </Card.Header>
            {id && getLoader ? (
              <div className="mt-5 mb-5 pt-5 pb-5 d-flex justify-content-center text-center align-items-center">
                <Smloader />
              </div>
            ) : (
              <Card.Body>
                <div className="row gy-3 justify-content-between">
                  <Col xxl={12} xl={12} sm={12}>
                    <Form.Label htmlFor="input-file">Upload icon</Form.Label>
                    <Form.Control
                      type="file"
                      id="icon"
                      name="icon"
                      onChange={handleFileChange}
                    />
                    {errors.icon && touched.icon && (
                      <div className="text-danger mt-1">{errors.icon}</div>
                    )}
                  </Col>
                  <Col xxl={8} xl={12}>
                    <div className="row gy-3">
                      <Col xl={6}>
                        <Form.Label
                          htmlFor="input-placeholder"
                          className="form-label"
                        >
                          Topic
                        </Form.Label>
                        <Form.Control
                          type="text"
                          id="topic"
                          name="topic"
                          placeholder="Enter Topic"
                          onChange={handleChange}
                          value={handleValue.topic}
                        />
                        {errors.topic && touched.topic && (
                          <div className="text-danger mt-1">{errors.topic}</div>
                        )}
                      </Col>
                      <Col xl={6}>
                        <Form.Label
                          htmlFor="input-placeholder"
                          className="form-label"
                        >
                          Category
                        </Form.Label>
                        <Form.Control
                          type="text"
                          id="category"
                          name="category"
                          placeholder="Enter Category"
                          onChange={handleChange}
                          value={handleValue.category}
                        />
                        {errors.category && touched.category && (
                          <div className="text-danger mt-1">
                            {errors.category}
                          </div>
                        )}
                      </Col>
                      <Col xl={12}>
                        <Form.Label className="form-label" htmlFor="prompt">
                          Prompt
                        </Form.Label>
                        <Form.Control
                          rows={4}
                          as="textarea"
                          id="prompt"
                          name="prompt"
                          onChange={handleChange}
                          value={handleValue.prompt}
                          placeholder="Enter Prompt"
                        />
                        {errors.prompt && touched.prompt && (
                          <div className="text-danger mt-1">
                            {errors.prompt}
                          </div>
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
                          placeholder="Enter Description"
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
                disabled={isEqual || loader || getLoader || imgLoader}
              >
                {imgLoader || loader || getLoader ? (
                  <Smloader size={"spinner-border-sm"} />
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
              <Card.Title>Assistant Preview</Card.Title>
            </Card.Header>
            <Card.Body>
              <Card className="custom-card mb-0 p-4 shadow-none border">
                <img
                  width={50}
                  src={
                    (file && URL.createObjectURL(file)) ||
                    handleValue.icon ||
                    image18
                  }
                  className="card-img-left my-3"
                  alt="..."
                  loading="lazy"
                />
                <div className="">
                  <p className={`fw-bold text-truncate`}>
                    {handleValue.topic || "Topic"}
                  </p>
                </div>
                <p className="mb-2">
                  {handleValue.description || "Description"}
                </p>
              </Card>
            </Card.Body>
          </Card>
        </Col>
      </Row>
    </Fragment>
  );
};

export default CreateScreen;
