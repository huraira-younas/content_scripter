import { Fragment } from "react";
import { Modal, Button, Form, Card } from "react-bootstrap";

const Model = ({
  values,
  errors,
  trigger,
  touched,
  handleValue,
  activeButton,
  handleSubmit,
  handleChange,
  handleCloseModal,
}) => {
  const valuesChanged =
    values &&
    handleValue.title.trim("") === values?.title &&
    handleValue.text.trim("") === values?.text;

  return (
    <Fragment>
      <Modal
        show={
          trigger === "createAll" ||
          trigger === "create" ||
          trigger === "update"
        }
        onHide={handleCloseModal}
      >
        <Modal.Header >
          <Modal.Title as="h5">{`Create ${
            trigger !== "createAll" ? activeButton : ""
          }`}</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form>
            {trigger === "createAll" && (
              <Form.Group>
                <Form.Label>Category Name:</Form.Label>
                <Form.Control
                  type="text"
                  placeholder="Enter main title here"
                  autoFocus
                  id="category"
                  name="category"
                  onChange={handleChange}
                  value={handleValue.category}
                />
                {errors.category && touched.category && (
                  <div className="text-danger mt-1">{errors.category}</div>
                )}
              </Form.Group>
            )}
            <div className="mt-2">
              <Form.Group className=" w-100 ">
                <Form.Label>
                  {trigger !== "createAll" ? activeButton : ""} Title:
                </Form.Label>
                <Form.Control
                  type="text"
                  placeholder="Enter title from here"
                  id="title"
                  name="title"
                  onChange={handleChange}
                  value={handleValue.title}
                />
                {errors.title && touched.title && (
                  <div className="text-danger mt-1">{errors.title}</div>
                )}
                <Form.Label className="form-label mt-2">
                  {trigger !== "createAll" ? activeButton : ""} Description
                </Form.Label>
                <div className="gap-3">
                  <Form.Control
                    as="textarea"
                    rows={4}
                    placeholder="Enter Description from here"
                    id="text"
                    name="text"
                    onChange={handleChange}
                    value={handleValue.text}
                  ></Form.Control>
                  {errors.text && touched.text && (
                    <div className="text-danger mt-1">{errors.text}</div>
                  )}
                </div>
              </Form.Group>
            </div>
          </Form>
        </Modal.Body>
        <Modal.Footer>
          <Button variant="danger-transparent" onClick={handleCloseModal}>
            Close
          </Button>
          <Button
            variant="primary-transparent"
            disabled={valuesChanged}
            onClick={handleSubmit}
          >
            {"Confirm"}
          </Button>
        </Modal.Footer>
      </Modal>
    </Fragment>
  );
};

export default Model;
