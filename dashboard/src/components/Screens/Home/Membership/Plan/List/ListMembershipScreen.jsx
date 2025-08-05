import { Button, Card, Col, Row, Table, Form, Dropdown } from "react-bootstrap";
import ConfirmModel from "../../../../../common/ConfirmModel/ConfirmModel";
import { calculateDays, formatTime } from "../../../../../../utils/utils";
import Smloader from "../../../../../common/smloader/smloader";
import Pageheader from "../../../../../pageheader/pageheader";
import { Link, useNavigate } from "react-router-dom";
import { ToastContainer } from "react-toastify";

const ListMembershipScreen = ({
  handleCloseModal,
  handleOpenModal,
  setSearchInput,
  membershipTime,
  selectedIndex,
  confirmModal,
  handleDelete,
  filteredUser,
  handleSelect,
  selectedTime,
  searchInput,
  loader,
}) => {
  const navigate = useNavigate();

  return (
    <div>
      <Pageheader
        active={"Manage Plans"}
        title={"Manage Plans"}
        heading={"Membership"}
      />
      <Row className=" mb-5">
        <Col className="col-12 col-md-12 col-lg-12">
          <Card className="custom-card table-responsive">
            <Card.Header className=" justify-content-between">
              <Card.Title>
                Plans - {` `}
                {
                  filteredUser?.filter((plan) =>
                    plan.title.toLowerCase().includes(searchInput.toLowerCase())
                  )?.length
                }
              </Card.Title>
              <div className="d-flex">
                <div className="me-2">
                  <Form.Control
                    onChange={(e) => setSearchInput(e.target.value)}
                    className="form-control form-control-sm"
                    aria-label=".form-control-sm example"
                    placeholder="Search Memberships"
                    value={searchInput}
                    type="text"
                  />
                </div>
                <Dropdown onSelect={handleSelect}>
                  <Dropdown.Toggle
                    className="btn  btn-sm btn-wave waves-effect waves-light no-caret"
                    data-bs-toggle="dropdown"
                    aria-expanded="false"
                    id="dropdown-basic"
                    variant="primary"
                  >
                    {loader
                      ? "1 week"
                      : !selectedTime
                      ? calculateDays(membershipTime[0]?.time)
                      : calculateDays(selectedTime)}
                  </Dropdown.Toggle>

                  <Dropdown.Menu>
                    {membershipTime?.map((time, index) => (
                      <Dropdown.Item
                        key={index}
                        eventKey={index}
                        id={time.time}
                      >
                        {calculateDays(time.time)}
                      </Dropdown.Item>
                    ))}
                  </Dropdown.Menu>
                </Dropdown>
                <Button
                  onClick={() => navigate("/dashboard/memberships/create")}
                  className="py-0 text-nowrap mx-2"
                >
                  Add Plan +
                </Button>
              </div>
            </Card.Header>
            {loader ? (
              <div className="d-flex justify-content-center text-center align-items-center w-100 my-5">
                <Smloader size={"spinner-border-md text-primary"} />
              </div>
            ) : (
              <Card.Body>
                <div className="table-responsive" style={{ overflowX: "auto" }}>
                  <Table bordered hover className="table text-nowrap border">
                    <thead>
                      <tr>
                        <th scope="col">Id</th>
                        <th scope="col">Tittle</th>
                        <th scope="col">Price</th>
                        <th scope="col">Discount</th>
                        <th scope="col">File Uploads</th>
                        <th scope="col">Prompts</th>
                        <th scope="col">Ads On</th>
                        <th scope="col">Features</th>
                        <th scope="col">Action</th>
                      </tr>
                    </thead>
                    <tbody>
                      {filteredUser
                        ?.filter((plan) =>
                          plan.title
                            .toLowerCase()
                            .includes(searchInput.toLowerCase())
                        )
                        .map((plan, idx) => {
                          const {
                            title,
                            price,
                            isAdsOn,
                            features,
                            fileInput,
                            promptsLimit,
                            resetDuration,
                            _id,
                          } = plan;
                          return (
                            <tr key={idx}>
                              <td>{idx + 1}</td>
                              <td>{title}</td>
                              <td>
                                {" "}
                                {price * membershipTime[selectedIndex]?.time ===
                                0
                                  ? "0$"
                                  : ` ${
                                      price *
                                      membershipTime[selectedIndex]?.time
                                        ? price *
                                          membershipTime[selectedIndex]?.time
                                        : 0
                                    }$`}
                              </td>
                              <td>
                                {membershipTime[selectedIndex]?.discount &&
                                price ? (
                                  <span>
                                    <span className="">
                                      {membershipTime[selectedIndex]?.discount *
                                        100}{" "}
                                      %
                                    </span>
                                  </span>
                                ) : (
                                  <span>0 %</span>
                                )}
                              </td>
                              <td>
                                <span className="text-muted">
                                  <span className="badge bg-success-transparent ms-1">
                                    {fileInput.image === -1
                                      ? "unlimited"
                                      : `amount ${fileInput.image}`}
                                  </span>{" "}
                                  {fileInput.image !== -1 && (
                                    <span className="badge bg-success-transparent ms-1">
                                      time {formatTime(resetDuration.fileInput)}
                                    </span>
                                  )}
                                </span>
                              </td>
                              <td>
                                <span className="text-muted">
                                  <span className="badge bg-success-transparent ms-1">
                                    {promptsLimit.max === -1
                                      ? "unlimited"
                                      : `amount ${promptsLimit.max}`}
                                  </span>{" "}
                                  {promptsLimit.max !== -1 && (
                                    <span className="badge bg-success-transparent ms-1">
                                      time {formatTime(resetDuration.prompts)}
                                    </span>
                                  )}
                                </span>
                              </td>
                              <td>
                                <span className="text-muted">
                                  {!isAdsOn ? (
                                    <span className="badge bg-danger-transparent text-default ms-1">
                                      <i className="ri-close-line align-middle fw-semibold"></i>
                                    </span>
                                  ) : (
                                    <span className="badge bg-success-transparent text-default ms-1">
                                      <i className="ri-check-line align-middle fw-semibold"></i>
                                    </span>
                                  )}
                                </span>
                              </td>
                              <td>
                                {features.map((feature, index) => (
                                  <span
                                    key={index}
                                    className="badge bg-success-transparent text-default ms-1"
                                  >
                                    {feature}
                                  </span>
                                ))}
                              </td>
                              <td>
                                <Button
                                  aria-label="anchor"
                                  variant="primary-light"
                                  className="btn btn-icon btn-wave waves-effect waves-light btn-sm btn-primary-light"
                                  onClick={() =>
                                    navigate(
                                      `/dashboard/memberships/update/${_id}`
                                    )
                                  }
                                >
                                  <i className="ri-edit-line"></i>
                                </Button>
                                <Link
                                  aria-label="anchor"
                                  to="#"
                                  onClick={() => handleOpenModal(_id)}
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

        <ConfirmModel
          handleCloseModal={handleCloseModal}
          handleConfirm={handleDelete}
          showModal={confirmModal}
        />
      </Row>
      <ToastContainer />
    </div>
  );
};

export default ListMembershipScreen;
