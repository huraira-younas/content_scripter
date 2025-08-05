import { Form, Modal } from "react-bootstrap";

const FilterModal = ({ showModal, handleCloseModal, gender, setGender }) => {
  const handleGenderChange = (event) => {
    setGender(event.target.value);
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
              type="radio"
              label={<span className="pointer-cursor">Male</span>}
              id="male"
              name="gender"
              value="male"
              checked={gender === "male"}
              onChange={handleGenderChange}
              onClick={handleCloseModal}
            />
          </div>
          <div className="form-check mb-2">
            <Form.Check
              className="form-check-inline pointer-cursor"
              type="radio"
              label={<span className="pointer-cursor">Female</span>}
              id="female"
              name="gender"
              value="female"
              checked={gender === "female"}
              onChange={handleGenderChange}
              onClick={handleCloseModal}
            />
          </div>
          <div className="form-check mb-2">
            <Form.Check
              className="form-check-inline pointer-cursor"
              type="radio"
              label={<span className="pointer-cursor">Non-Binary</span>}
              id="binary"
              name="gender"
              value="non-binary"
              checked={gender === "non-binary"}
              onChange={handleGenderChange}
              onClick={handleCloseModal}
            />
          </div>
        </Modal.Body>
      </Modal>
    </div>
  );
};

export default FilterModal;
