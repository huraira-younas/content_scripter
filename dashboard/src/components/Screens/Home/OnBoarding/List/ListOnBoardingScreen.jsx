import { useSelector } from "react-redux";
import Pageheader from "../../../../pageheader/pageheader";
import Smloader from "../../../../common/smloader/smloader";
import {
  Button,
  Card,
  Col,
  Form,
  Image,
  Modal,
  Row,
  Table,
} from "react-bootstrap";
import { Link, createSearchParams, useNavigate } from "react-router-dom";
import { selectDeleteOnboardingLoader } from "../../../../../pages/selectors";

const OnBoardingScreen = ({
  onBoarding,
  searchInput,
  showModal,
  selectedImage,
  handleOpenModal,
  handleClose,
  handleImageClick,
  setSearchInput,
  loader,
}) => {
  const navigate = useNavigate();

  return (
    <>
      <Pageheader
        title={"Manage Onboarding"}
        heading={"Onboarding"}
        active={"List Onboarding"}
      />
      <Row>
        <Col lg={12} md={12}>
          <Card className="custom-card">
            <Card.Header className=" justify-content-between">
              <Card.Title>
                OnBoarding -{" "}
                {
                  onBoarding?.filter(
                    (plan) =>
                      plan?.title
                        ?.toLowerCase()
                        .includes(searchInput?.toLowerCase()) ||
                      plan?.description
                        ?.toLowerCase()
                        .includes(searchInput?.toLowerCase())
                  ).length
                }
              </Card.Title>
              <div className="d-flex">
                <div className="me-2">
                  <Form.Control
                    className="form-control form-control-sm"
                    type="text"
                    placeholder="search onboarding"
                    aria-label=".form-control-sm example"
                    value={searchInput}
                    onChange={(e) => setSearchInput(e.target.value)}
                  />
                </div>
                <Button
                  className="py-0 text-nowrap mx-2"
                  onClick={() => navigate("/on-boarding/create")}
                >
                  Add OnBoarding +
                </Button>
              </div>
            </Card.Header>
            {loader ? (
              <div className="mt-5 mb-5 pt-5 pb-5 d-flex justify-content-center text-center align-items-center">
                <Smloader size={"spinner-border-md text-primary"} />
              </div>
            ) : (
              <Card.Body>
                <div className="" style={{ overflowX: "auto" }}>
                  <Table bordered hover className="table text-nowrap border">
                    <thead>
                      <tr>
                        <th scope="col">Page No</th>
                        <th scope="col">Image</th>
                        <th scope="col">Title</th>
                        <th scope="col">Description</th>
                        <th scope="col">Action</th>
                      </tr>
                    </thead>
                    <tbody>
                      {onBoarding
                        ?.filter(
                          (plan) =>
                            plan.title
                              .toLowerCase()
                              .includes(searchInput.toLowerCase()) ||
                            plan.description
                              .toLowerCase()
                              .includes(searchInput.toLowerCase())
                        )
                        ?.sort((a, b) => a.index - b.index)
                        ?.map((item, idx) => {
                          return (
                            <tr key={item._id}>
                              <td>{item.index}</td>
                              <td>
                                <div className=" img-fluid">
                                  <Image
                                    width={40}
                                    src={item.imageUrl}
                                    className="img-fluid object-fit-cover "
                                    alt="..."
                                    style={{
                                      cursor: "pointer",
                                    }}
                                    onClick={() =>
                                      handleImageClick(item.imageUrl)
                                    }
                                  />
                                </div>
                              </td>
                              <td>
                                <p className={`fw-bold text-truncate `}>
                                  {item.title}
                                </p>
                              </td>
                              <td>
                                <p
                                  className={`fw-semibold text-truncate negative-margin`}
                                  style={{ maxWidth: "400px" }}
                                >
                                  {item.description}
                                </p>
                              </td>

                              <td>
                                <Link
                                  aria-label="anchor"
                                  variant="primary-light"
                                  className="btn btn-icon btn-wave waves-effect waves-light btn-sm btn-primary-light"
                                  to={`/on-boarding/update/${item._id}`}
                                >
                                  <i className="ri-edit-line"></i>
                                </Link>
                                <Link
                                  aria-label="anchor"
                                  to="#"
                                  onClick={() =>
                                    handleOpenModal(item._id, item.imageUrl)
                                  }
                                  className="btn btn-icon mx-1 btn-wave waves-effect waves-light btn-sm btn-danger-light"
                                >
                                  <i className="ri-delete-bin-5-line"></i>
                                </Link>
                              </td>
                            </tr>
                          );
                        })}
                    </tbody>
                  </Table>
                </div>
              </Card.Body>
            )}
          </Card>
        </Col>
        <Modal show={showModal} onHide={handleClose} centered>
          <Modal.Body>
            <Image src={selectedImage} className="img-fluid" />
          </Modal.Body>
        </Modal>
      </Row>
    </>
  );
};

export default OnBoardingScreen;
