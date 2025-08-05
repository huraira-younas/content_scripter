import React, { Fragment, useState } from "react";
import { Modal, Button, Form } from "react-bootstrap";
import { handleInputChange } from "../../../../../../utils/utils";

const MembershipTimeModal = ({
  showModal,
  handleCloseModal,
  handleSubmit,
  handleChange,
  handleValue,
  touched,
  errors,
  values,
}) => {
  const valuesChanged =
    values &&
    handleValue.time == values?.time &&
    handleValue.discount == values?.discount;

  return (
    <Fragment>
      <Modal show={showModal} onHide={handleCloseModal}>
        <Modal.Header closeButton>
          <Modal.Title as="h6">Edit Membership Duration:</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form>
            <Form.Group controlId="exampleForm.ControlInput1">
              <Form.Label>Duration: (in days)</Form.Label>
              <Form.Control
                type="text"
                placeholder="Enter time for membership"
                name="time"
                value={handleValue.time}
                onChange={(e) => handleInputChange(e, handleChange)}
              />
              {errors.time && touched.time && (
                <div className="text-danger mt-1">{errors.time}</div>
              )}
              <Form.Label>Discount:</Form.Label>
              <Form.Control
                type="text"
                name="discount"
                placeholder="Enter discount for membership"
                value={handleValue.discount}
                onChange={(e) => handleInputChange(e, handleChange)}
              />
              {errors.discount && touched.discount && (
                <div className="text-danger mt-1">{errors.discount}</div>
              )}
            </Form.Group>
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
            Confirm
          </Button>
        </Modal.Footer>
      </Modal>
    </Fragment>
  );
};

export default MembershipTimeModal;
