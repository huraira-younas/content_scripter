import { Fragment } from "react";
import { Modal, Button, Form } from "react-bootstrap";
import Smloader from "../../../../../common/smloader/smloader";

const Model = ({
  values,
  errors,
  loader,
  fileOne,
  touched,
  isUpdate,
  showModal,
  handleValue,
  handleChange,
  handleSubmit,
  handleCloseModal,
  handleFileOneChange,
}) => {
  const valuesChanged =
    handleValue.title.trim("") !== values?.title ||
    handleValue.text.trim("") !== values?.text ||
    fileOne !== null ||
    (isUpdate && handleValue.icon !== values?.icon);

  return (
    <Fragment>
      <Modal show={showModal} onHide={handleCloseModal}>
        <Modal.Header>
          <Modal.Title as="h6">
            {!isUpdate ? "Create Privacy Policy:" : "Update Privacy Policy:"}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form>
            <Form.Group className="p-2 rounded-1 ">
              <Form.Label>Title:</Form.Label>
              <Form.Control
                type="text"
                placeholder="Enter title for Contact"
                autoFocus
                id="title"
                name="title"
                onChange={handleChange}
                value={handleValue.title}
              />
              {errors.title && touched.title && (
                <div className="text-danger mt-1">{errors.title}</div>
              )}
              <Form.Label className="form-label mt-2">Link</Form.Label>
              <Form.Control
                as="textarea"
                rows={4}
                placeholder="Enter link"
                id="text"
                name="text"
                onChange={handleChange}
                value={handleValue.text}
              />
              {errors.text && touched.text && (
                <div className="text-danger mt-1">{errors.text}</div>
              )}
              <Form.Label className="mt-2">Upload Icon</Form.Label>
              <div className="d-flex gap-4 align-items-start ">
                <Form.Control
                  type="file"
                  accept="image/*"
                  onChange={handleFileOneChange}
                  className="w-50"
                  id="icon"
                />
                {(fileOne || handleValue.icon) && (
                  <img
                    src={
                      (fileOne && URL.createObjectURL(fileOne)) ||
                      handleValue.icon
                    }
                    alt="icon"
                    style={{ width: "40px", height: "40px" }}
                  />
                )}

                {errors.icon && touched.icon && (
                  <div className="text-danger mt-1">{errors.icon}</div>
                )}
              </div>
            </Form.Group>
          </Form>
        </Modal.Body>
        <Modal.Footer>
          <Button variant="danger-transparent" onClick={handleCloseModal}>
            Close
          </Button>
          <Button
            variant="primary-transparent"
            disabled={!valuesChanged}
            onClick={handleSubmit}
          >
            {loader ? <Smloader /> : "Confirm"}
          </Button>
        </Modal.Footer>
      </Modal>
    </Fragment>
  );
};

export default Model;
