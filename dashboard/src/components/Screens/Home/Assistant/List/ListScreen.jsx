import { selectDeleteOnboardingLoader } from "../../../../../pages/selectors";
import Smloader from "../../../../common/smloader/smloader";
import Pageheader from "../../../../pageheader/pageheader";
import { Link, useNavigate } from "react-router-dom";
import { useSelector } from "react-redux";
import {
  Row,
  Col,
  Card,
  Form,
  Image,
  Modal,
  Table,
  Button,
} from "react-bootstrap";

const ListScreen = ({
  handleImageClick,
  handleOpenModal,
  setSearchInput,
  selectedImage,
  handleClose,
  searchInput,
  assistant,
  showModal,
  loader,
}) => {
  const navigate = useNavigate();
  const deleteLoader = useSelector(selectDeleteOnboardingLoader);

  return (
    <>
      <Pageheader
        active={"Manage Assistant"}
        title={"Manage Assistant"}
        heading={"Assistant"}
      />
      <Row>
        <Col lg={12} md={12}>
          <Card className="custom-card">
            <Card.Header className=" justify-content-between">
              <Card.Title>
                Assistant -{" "}
                {
                  assistant?.filter(
                    (plan) =>
                      plan?.topic
                        ?.toLowerCase()
                        .includes(searchInput?.toLowerCase()) ||
                      plan?.category
                        ?.toLowerCase()
                        .includes(searchInput?.toLowerCase())
                  ).length
                }
              </Card.Title>
              <div className="d-flex">
                <div className="me-2">
                  <Form.Control
                    onChange={(e) => setSearchInput(e.target.value)}
                    className="form-control form-control-sm"
                    aria-label=".form-control-sm example"
                    placeholder="search assistant"
                    value={searchInput}
                    type="text"
                  />
                </div>
                <Button
                  onClick={() => navigate("/dashboard/assistant/create")}
                  className="py-0 text-nowrap mx-2"
                >
                  Add Assistant +
                </Button>
              </div>
            </Card.Header>
            {loader || deleteLoader ? (
              <div className="mt-5 mb-5 pt-5 pb-5 d-flex justify-content-center text-center align-items-center">
                <Smloader size={"spinner-border-md text-primary"} />
              </div>
            ) : (
              <Card.Body>
                <div className="" style={{ overflowX: "auto" }}>
                  <Table bordered hover className="table text-nowrap border">
                    <thead>
                      <tr>
                        <th scope="col">Item no</th>
                        <th scope="col">Icon</th>
                        <th scope="col">Category</th>
                        <th scope="col">Topic</th>
                        <th scope="col">Prompt</th>
                        <th scope="col">Description</th>
                      </tr>
                    </thead>
                    <tbody>
                      {assistant
                        ?.filter(
                          (plan) =>
                            plan.topic
                              .toLowerCase()
                              .includes(searchInput.toLowerCase()) ||
                            plan.category
                              .toLowerCase()
                              .includes(searchInput.toLowerCase())
                        )
                        ?.sort((a, b) => a.index - b.index)
                        ?.map((item, idx) => {
                          return (
                            <tr key={item._id}>
                              <td>{idx + 1}</td>
                              <td>
                                <div className="text-center img-fluid">
                                  <Image
                                    src={item.icon}
                                    className="img-fluid object-fit-cover "
                                    alt="..."
                                    style={{
                                      cursor: "pointer",
                                      // display: imgLoaders[idx] ? "none" : "inline",
                                      height: "30px",
                                    }}
                                    // onLoad={() => handleImageLoad(idx)}
                                    onClick={() => handleImageClick(item.icon)}
                                  />
                                </div>
                              </td>
                              <td>
                                <p className={`fw-bold text-truncate `}>
                                  {item.category}
                                </p>
                              </td>
                              <td>
                                <p
                                  className={`fw-semibold text-truncate negative-margin`}
                                  style={{ maxWidth: "400px" }}
                                >
                                  {item.topic}
                                </p>
                              </td>
                              <td>
                                <p
                                  className={`fw-semibold text-truncate negative-margin`}
                                  style={{ maxWidth: "400px" }}
                                >
                                  {item.prompt}
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
                                  // onClick={() =>
                                  //   navigate(`${item._id}`)
                                  // }
                                  to={`/assistant/update/${item._id}`}
                                >
                                  <i className="ri-edit-line"></i>
                                </Link>
                                <Link
                                  aria-label="anchor"
                                  to="#"
                                  onClick={() =>
                                    handleOpenModal(item._id, item.icon)
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
            <center>
              <Image src={selectedImage} className="img-fluid" />
            </center>
          </Modal.Body>
        </Modal>
      </Row>
    </>
  );
};

export default ListScreen;
