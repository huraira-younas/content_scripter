import React from "react";
import { Button, Modal } from "react-bootstrap";
import Smloader from "../smloader/smloader";

const ConfirmModel = ({
  showModal,
  handleCloseModal,
  handleConfirm,
  loader,
}) => {
  return (
    <div>
      <Modal show={showModal} onHide={handleCloseModal}>
        <Modal.Header>
          <Modal.Title as="h6" className="">
            Deleted Data
          </Modal.Title>
        </Modal.Header>
        <Modal.Body className="text-primary">
          Are you sure you want to delete?
        </Modal.Body>
        <Modal.Footer>
          <Button variant="primary" onClick={handleCloseModal}>
            No
          </Button>
          <Button disabled={loader} variant="danger" onClick={handleConfirm}>
            {loader ? <Smloader /> : "Yes"}
          </Button>
        </Modal.Footer>
      </Modal>
    </div>
  );
};

export default ConfirmModel;
