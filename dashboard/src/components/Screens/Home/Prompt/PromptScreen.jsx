import React from "react";
import { Card, Col, Form, InputGroup, Row, Tab } from "react-bootstrap";
import Pageheader from "../../../pageheader/pageheader";
import Smloader from "../../../common/smloader/smloader";
import { handleInputChange } from "../../../../utils/utils";

const PromptScreen = ({
  handleValue,
  handleChange,
  handleSubmit,
  touched,
  errors,
  loader,
  prompt,
}) => {
  const valuesChanged =
    prompt &&
    prompt.defaultPrompt == handleValue.defaultPrompt &&
    prompt.model == handleValue.model &&
    prompt.modelApiKey == handleValue.modelApiKey &&
    prompt.tagsApiKey == handleValue.tagsApiKey;

  return (
    <>
      <Pageheader title={"Prompt"} heading={"Prompt"} active={"Prompt"} />
      <Row className="">
        <Col md={12}>
          <Card className="custom-card">
            <Tab.Container defaultActiveKey="one">
              <div className="p-3 fs-6 fw-medium">
                <p>Manage Prompt</p>
              </div>

              {loader ? (
                <div className="mt-5 mb-5 pt-5 pb-5 d-flex justify-content-center text-center align-items-center">
                  <Smloader />
                </div>
              ) : (
                <Card.Body className="p-3 gap-4 d-flex flex-column ">
                  <div className="">
                    {/* <p className="fs-6 fw-medium">Search Radius</p>
                  <p>Enter minimum and maximum search radius</p> */}

                    <Col xl={12}>
                      <Form.Label htmlFor="model" className="">
                        Model
                      </Form.Label>
                      <Form.Control
                        type="text"
                        className=""
                        placeholder="Enter model"
                        name="model"
                        onChange={handleChange}
                        value={handleValue.model}
                      />
                      {errors.model && touched.model && (
                        <div className="text-danger mt-1">{errors.model}</div>
                      )}
                    </Col>
                    <Col xl={12}>
                      <Form.Label htmlFor="first-name" className="mt-4">
                        Tags Api Key
                      </Form.Label>
                      <Form.Control
                        type="text"
                        className=""
                        placeholder="Enter tags api key"
                        name="tagsApiKey"
                        onChange={handleChange}
                        value={handleValue.tagsApiKey}
                      />
                      {errors.tagsApiKey && touched.tagsApiKey && (
                        <div className="text-danger mt-1">
                          {errors.tagsApiKey}
                        </div>
                      )}
                    </Col>
                    <Col xl={12}>
                      <Form.Label htmlFor="first-name" className="mt-4">
                        Model Api Key
                      </Form.Label>
                      <Form.Control
                        type="text"
                        className=""
                        placeholder="Enter model api key"
                        name="modelApiKey"
                        onChange={handleChange}
                        value={handleValue.modelApiKey}
                      />
                      {errors.modelApiKey && touched.modelApiKey && (
                        <div className="text-danger mt-1">
                          {errors.modelApiKey}
                        </div>
                      )}
                    </Col>
                    <Col xl={12}>
                      <Form.Label
                        className="form-label mt-4"
                        htmlFor="nft-description"
                      >
                        Default Prompt
                      </Form.Label>
                      <Form.Control
                        rows={4}
                        as="textarea"
                        id="defaultPrompt"
                        name="defaultPrompt"
                        onChange={handleChange}
                        value={handleValue.defaultPrompt}
                        placeholder="Enter default prompt"
                      />
                      {errors.defaultPrompt && touched.defaultPrompt && (
                        <div className="text-danger mt-1">
                          {errors.defaultPrompt}
                        </div>
                      )}
                    </Col>
                  </div>
                </Card.Body>
              )}

              <Card.Footer className="p-2 float-end d-flex justify-content-end">
                <button
                  onClick={handleSubmit}
                  disabled={valuesChanged}
                  className="btn btn-primary m-1"
                  type="submit"
                >
                  {loader ? (
                    <Smloader size="spinner-border-sm" />
                  ) : (
                    "Save"
                  )}
                </button>
              </Card.Footer>
            </Tab.Container>
          </Card>
        </Col>
      </Row>
    </>
  );
};

export default PromptScreen;
