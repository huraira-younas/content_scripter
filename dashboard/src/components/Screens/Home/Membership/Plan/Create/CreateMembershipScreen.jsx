import React, { useEffect, useState } from "react";
import { Row, Col, Card, Form, Button, InputGroup } from "react-bootstrap";
import Checkbox from "../../../../../common/Checkbox/Checkbox";
import { handleInputChange } from "../../../../../../utils/utils";
import CreatableSelect from "react-select/creatable";
import Pageheader from "../../../../../pageheader/pageheader";
import Smloader from "../../../../../common/smloader/smloader";

const CreateMembershipScreen = ({
  id,
  value,
  errors,
  loader,
  touched,
  setValue,
  inputValue,
  handleValue,
  handleChange,
  featureError,
  handleSubmit,
  initialValues,
  setInputValue,
  handleKeyDown,
  setInitialValues,
}) => {
  const [formChanged, setFormChanged] = useState(false);
  useEffect(() => {
    if (initialValues) {
      const formValues = JSON.stringify(handleValue);
      const initialFormValues = JSON.stringify(initialValues);
      setFormChanged(formValues == initialFormValues);
    }
  }, [handleValue]);

  useEffect(() => {
    setInitialValues(handleValue);
  }, []);

  const components = {
    DropdownIndicator: null,
  };

  const time = [
    { title: "Minute", value: 60 },
    { title: "Hour", value: 3600 },
    { title: "Day", value: 86400 },
    { title: "Month", value: 2592000 },
  ];

  return (
    <div>
      <Pageheader
        title={`${!id && !loader ? "Create" : "Update"} Plans`}
        heading={"Membership"}
        active={`${!id && !loader ? "Create" : "Update"} Plans`}
      />
      <Card className="custom-card">
        <Card.Header className=" justify-content-between">
          <Card.Title>{!id && !loader ? "Create" : "Update"}</Card.Title>
        </Card.Header>
        <Card.Body>
          {loader ? (
            <div className="mt-5 mb-5 pt-5 pb-5 d-flex justify-content-center text-center align-items-center">
              <Smloader />
            </div>
          ) : (
            <Form>
              <Row>
                <Col md={6} className="mb-3">
                  <Form.Label className="">Title</Form.Label>
                  <Form.Control
                    type="text"
                    name="title"
                    className="form-control"
                    placeholder="Title"
                    aria-label="Title"
                    onChange={handleChange}
                    value={handleValue.title}
                  />
                  {errors.title && touched.title && (
                    <div className="text-danger mt-1">{errors.title}</div>
                  )}
                </Col>
                <Col md={6} className="mb-3">
                  <Form.Label className="">Price</Form.Label>
                  <Form.Control
                    type="text"
                    className="form-control"
                    placeholder="Price"
                    name="price"
                    aria-label="Price"
                    onChange={handleChange}
                    value={handleValue.price}
                  />
                  {errors.price && touched.price && (
                    <div className="text-danger mt-1">{errors.price}</div>
                  )}
                </Col>
                <Col className="mb-3">
                  <div className="d-flex justify-content-between  ">
                    <Form.Label className="">Image</Form.Label>
                    <Form.Check
                      type="checkbox"
                      label="Unlimited"
                      onChange={handleChange}
                      name="fileInput.unlimited"
                      value={handleValue?.fileInput?.unlimited}
                      checked={handleValue?.fileInput?.unlimited}
                    />
                  </div>
                  <Row>
                    <Col xl={12} className="mb-3">
                      <small className="text-muted ">Amount</small>
                      <Form.Control
                        type="text"
                        className=""
                        placeholder="Amount"
                        name="fileInput.image"
                        aria-label="Amount"
                        onChange={(e) => handleInputChange(e, handleChange)}
                        value={handleValue?.fileInput?.image}
                        disabled={handleValue?.fileInput?.unlimited}
                      />

                      {errors?.fileInput?.image &&
                        touched?.fileInput?.image && (
                          <div className="text-danger mt-1">
                            {errors?.fileInput?.image}
                          </div>
                        )}
                    </Col>
                    <Col xl={12} className="mb-3">
                      <small className="text-muted">Time</small>
                      <InputGroup>
                        <Form.Control
                          type="text"
                          className=""
                          placeholder="Time"
                          name="resetDuration.fileInput"
                          aria-label="time"
                          onChange={(e) => handleInputChange(e, handleChange)}
                          value={handleValue?.resetDuration?.fileInput}
                          disabled={handleValue?.fileInput?.unlimited}
                        />

                        <Form.Select
                          size="sm"
                          className="form-select form-select-sm "
                          aria-label=".form-select-sm example"
                          // onChange={(e) => setSeconds(e.target.value)}
                          name="resetDuration.fileSeconds"
                          onChange={handleChange}
                          value={handleValue?.resetDuration?.fileSeconds}
                          disabled={handleValue?.fileInput?.unlimited}
                        >
                          <option value={0}>Select</option>
                          {time.map((time, index) => {
                            const { value, title } = time;
                            return (
                              <option
                                key={index}
                                value={value}
                                // onClick={()=> setSeconds(value)}
                              >
                                {title}
                              </option>
                            );
                          })}
                        </Form.Select>
                      </InputGroup>
                      {(errors?.resetDuration?.fileInput ||
                        errors?.resetDuration?.fileSeconds) &&
                        (touched?.resetDuration?.fileInput ||
                          touched?.resetDuration?.fileSeconds) && (
                          <div className="text-danger mt-1">
                            {errors?.resetDuration?.fileInput ||
                              errors?.resetDuration?.fileSeconds}
                          </div>
                        )}
                    </Col>
                  </Row>
                </Col>
                <Col className="mb-3">
                  <div className="d-flex justify-content-between  ">
                    <Form.Label className="">Propmpt</Form.Label>
                    <Form.Check
                      type="checkbox"
                      label="Unlimited"
                      onChange={handleChange}
                      name="promptsLimit.unlimited"
                      value={handleValue?.promptsLimit?.unlimited}
                      checked={handleValue?.promptsLimit?.unlimited}
                    />
                  </div>
                  <Row>
                    <Col xl={12} className="mb-3">
                      <small className="text-muted ">Amount</small>
                      <Form.Control
                        type="text"
                        className=""
                        placeholder="Amount"
                        name="promptsLimit.max"
                        aria-label="Amount"
                        onChange={(e) => handleInputChange(e, handleChange)}
                        value={handleValue?.promptsLimit?.max}
                        disabled={handleValue?.promptsLimit?.unlimited}
                      />

                      {errors?.promptsLimit?.max &&
                        touched?.promptsLimit?.max && (
                          <div className="text-danger mt-1">
                            {errors?.promptsLimit?.max}
                          </div>
                        )}
                    </Col>
                    <Col xl={12} className="mb-3">
                      <small className="text-muted">Time</small>
                      <InputGroup>
                        <Form.Control
                          type="text"
                          className=""
                          placeholder="Time"
                          name="resetDuration.prompts"
                          aria-label="time"
                          onChange={(e) => handleInputChange(e, handleChange)}
                          value={handleValue?.resetDuration?.prompts}
                          disabled={handleValue?.prompts?.unlimited}
                        />
                        <Form.Select
                          size="sm"
                          className="form-select form-select-sm "
                          aria-label=".form-select-sm example"
                          // onChange={(e) => setSeconds(e.target.value)}
                          name="resetDuration.promptSeconds"
                          onChange={handleChange}
                          value={handleValue?.resetDuration?.promptSeconds}
                          disabled={handleValue?.prompts?.unlimited}
                        >
                          <option value={0}>Select</option>
                          {time.map((time, index) => {
                            const { value, title } = time;
                            return (
                              <option
                                key={index}
                                value={value}
                                // onClick={()=> setSeconds(value)}
                              >
                                {title}
                              </option>
                            );
                          })}
                        </Form.Select>
                      </InputGroup>

                      <div className="d-flex justify-content-between  ">
                        {errors?.resetDuration?.prompts &&
                          touched?.resetDuration?.prompts && (
                            <div className="text-danger mt-1">
                              {errors?.resetDuration?.prompts}
                            </div>
                          )}
                        {errors?.resetDuration?.promptSeconds &&
                          touched?.resetDuration?.promptSeconds && (
                            <div className="text-danger mt-1">
                              {errors?.resetDuration?.promptSeconds}
                            </div>
                          )}
                      </div>
                    </Col>
                  </Row>
                </Col>
                {/* <Col md={6} className="mb-3">
                <Form.Label className="">Free Boost</Form.Label>
                <Row>
                  <Col xl={12} className="mb-3">
                    <small className="text-muted">Amount</small>
                    <Form.Control
                      type="text"
                      className=""
                      placeholder="Amount"
                      aria-label="Amount"
                      name="freeBoost.amount"
                      onChange={(e) => handleInputChange(e, handleChange)}
                      value={handleValue.freeBoost.amount}
                    />

                    {errors.freeBoost?.amount && touched.freeBoost?.amount && (
                      <div className="text-danger mt-1">
                        {errors.freeBoost?.amount}
                      </div>
                    )}
                  </Col>
                  <Col xl={12} className="mb-3">
                    <small className="text-muted">Time</small>
                    <InputGroup>
                      <Form.Control
                        type="text"
                        className=""
                        placeholder="Time"
                        aria-label="Time"
                        name="freeBoost.time"
                        onChange={(e) => handleInputChange(e, handleChange)}
                        value={handleValue.freeBoost.time}
                      />

                      <Form.Select
                        size="sm"
                        className="form-select form-select-sm "
                        aria-label=".form-select-sm example"
                        // onChange={(e) => setSeconds(e.target.value)}
                        name="freeBoost.seconds"
                        onChange={handleChange}
                        value={handleValue.freeBoost.seconds}
                      >
                        <option value={0}>Select</option>
                        {time.map((time, index) => {
                          const { value, title } = time;
                          return (
                            <option
                              key={index}
                              value={value}
                              // onClick={()=> setSeconds(value)}
                            >
                              {title}
                            </option>
                          );
                        })}
                      </Form.Select>
                    </InputGroup>
                    <div className="d-flex justify-content-between ">
                      {errors.freeBoost?.time && touched.freeBoost?.time && (
                        <div className="text-danger mt-1">
                          {errors.freeBoost?.time}
                        </div>
                      )}
                      {errors.freeBoost?.seconds &&
                        touched.freeBoost?.seconds && (
                          <div className="text-danger mt-1">
                            {errors.freeBoost?.seconds}
                          </div>
                        )}
                    </div>
                  </Col>
                  <Col xl={12} className="mb-3">
                    <small className="text-muted">Duration</small>
                    <InputGroup>
                      <Form.Control
                        type="text"
                        className=""
                        placeholder="duration"
                        aria-label="duration"
                        name="freeBoost.duration"
                        onChange={(e) => handleInputChange(e, handleChange)}
                        value={handleValue.freeBoost.duration}
                      />

                      <Form.Select
                        size="sm"
                        className="form-select form-select-sm "
                        aria-label=".form-select-sm example"
                        // onChange={(e) => setSeconds(e.target.value)}
                        id="duration"
                        name="freeBoost.durationSeconds"
                        onChange={handleChange}
                        value={handleValue.freeBoost.durationSeconds}
                      >
                        <option value={0}>Select</option>
                        {time.map((time, index) => {
                          const { value, title } = time;
                          return (
                            <option
                              key={index}
                              value={value}
                              // onClick={()=> setSeconds(value)}
                            >
                              {title}
                            </option>
                          );
                        })}
                      </Form.Select>
                    </InputGroup>
                    <div className="d-flex justify-content-between ">
                      {errors.freeBoost?.duration &&
                        touched.freeBoost?.duration && (
                          <div className="text-danger mt-1">
                            {errors.freeBoost?.duration}
                          </div>
                        )}
                      {errors.freeBoost?.durationSeconds &&
                        touched.freeBoost?.durationSeconds && (
                          <div className="text-danger mt-1 text-end ">
                            {errors.freeBoost?.durationSeconds}
                          </div>
                        )}
                    </div>
                  </Col>
                </Row>
              </Col> */}

                {/* <Col md={6} className="my-3 ">
                <Row className="text-center ">
                  <Col md={6} className="my-2">
                    <Checkbox
                      title={"See Sparks"}
                      name={"seeSparks"}
                      value={handleValue.seeSparks}
                      onChange={handleChange}
                    />
                  </Col>

                  <Col md={6} className="my-2">
                    <Checkbox
                      title={"Text Messages"}
                      value={handleValue.textMessages}
                      name={"textMessages"}
                      onChange={handleChange}
                    />
                  </Col>
                </Row>
                <Row className="text-center mt-3">
                  <Col md={6} className="my-2">
                    <Checkbox
                      title={"Text Messages"}
                      value={handleValue.telLocation}
                      name={"telLocation"}
                      onChange={handleChange}
                    />
                  </Col>

                  <Col md={6} className="my-2">
                    <Checkbox
                      title={"HideAds"}
                      value={handleValue.hideAds}
                      name={"hideAds"}
                      onChange={handleChange}
                    />
                  </Col>
                </Row>
                <Row className="text-center mt-3">
                  <Col md={6} className="my-2">
                    <Checkbox
                      title={"Incognito"}
                      value={handleValue.incognito}
                      name={"incognito"}
                      onChange={handleChange}
                    />
                  </Col>

                  <Col md={6} className="my-2">
                    <Checkbox
                      title={"Video Meet"}
                      value={handleValue.videoMeet}
                      name={"videoMeet"}
                      onChange={handleChange}
                    />
                  </Col>
                </Row>
              </Col> */}
                {/* <Row className="my-2"> */}
                <Col md={12} className="mb-3">
                  <Card className="custom-card">
                    <Form.Label className="">Features</Form.Label>
                    <CreatableSelect
                      components={components}
                      classNamePrefix="react-select"
                      inputValue={inputValue}
                      isClearable
                      isMulti
                      menuIsOpen={false}
                      onChange={(newValue) => {
                        if (Array.isArray(newValue)) {
                          setValue(newValue);
                        } else {
                          setValue([]);
                        }
                      }}
                      onInputChange={(newValue) => setInputValue(newValue)}
                      onKeyDown={handleKeyDown}
                      placeholder="Type feature and press enter"
                      value={value}
                    />
                  </Card>

                  {featureError && (
                    <div className="text-danger mt-1">{featureError}</div>
                  )}
                </Col>
                {/* </Row> */}
                <Col md={6} className="my-2">
                  <Checkbox
                    title={"Ads On"}
                    name={"isAdsOn"}
                    value={handleValue.isAdsOn}
                    onChange={handleChange}
                  />
                </Col>
              </Row>
            </Form>
          )}
        </Card.Body>
        <Card.Footer>
          <Col className="my-3 text-end ">
            <Button
              onClick={handleSubmit}
              variant="primary"
              disabled={loader || formChanged}
              className=""
            >
              Save
            </Button>
          </Col>
        </Card.Footer>
      </Card>
    </div>
  );
};

export default CreateMembershipScreen;
