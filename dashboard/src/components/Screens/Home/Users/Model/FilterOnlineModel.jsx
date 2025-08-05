import { Form, Modal } from "react-bootstrap";

const FilterOnlineModal = ({
  showModal,
  handleCloseModal,
  setOnline,
  online,
}) => {
  const handleOnlineChange = (event) => {
    setOnline(event.target.value);
  };

  const handleOflineChange = () => {
    setOnline("");
  };

  return (
    <div>
      <Modal show={showModal} onHide={handleCloseModal}>
        <Modal.Header closeButton>
          <Modal.Title as="h6" className="">
            Select Gender
          </Modal.Title>
        </Modal.Header>
        <Modal.Body className="text-primary">
          <div className="form-check mb-2">
            <Form.Check
              className="form-check-inline pointer-cursor"
              label={<span className="pointer-cursor">Online</span>}
              type="radio"
              id="online"
              name="user"
              value="true"
              checked={online === "true"}
              onChange={handleOnlineChange}
              onClick={handleCloseModal}
            />
          </div>
          <div className="form-check mb-2">
            <Form.Check
              className="form-check-inline pointer-cursor"
              label={<span className="pointer-cursor">Ofline</span>}
              type="radio"
              id="ofline"
              name="user"
              value="false"
              checked={online === "false"}
              onChange={handleOflineChange}
              onClick={handleCloseModal}
            />
          </div>
        </Modal.Body>
      </Modal>
    </div>
  );
};

export default FilterOnlineModal;
