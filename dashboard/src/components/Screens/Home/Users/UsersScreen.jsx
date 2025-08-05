import React from "react";
import { Link } from "react-router-dom";
import Pageheader from "../../../pageheader/pageheader";
import { Card, Col, Dropdown, Form, Row, Table } from "react-bootstrap";
import { CountryDropdown } from "react-country-region-selector";
import PaginationComponent from "../../../Pagination/PaginationComponent";
import Smloader from "../../../common/smloader/smloader";

const UsersScreen = ({
  users,
  limit,
  loader,
  totalPages,
  totalUsers,
  currentPage,
  searchUsers,
  setSearchUsers,
  setCurrentPage,
  selectedCountry,
  setSelectedCountry,
}) => {
  return (
    <>
      <Pageheader
        title={"Manage users"}
        heading={"Users"}
        active={"Manage users"}
      />
      <Row>
        <Col>
          <Card className="custom-card table-responsive">
            <Card.Header className=" justify-content-between">
              <Card.Title>Users - {totalUsers}</Card.Title>
              <div className="d-flex justify-content-end">
                <div className="me-3">
                  <Form>
                    <Form.Control
                      className="form-control form-control-sm"
                      type="text"
                      placeholder="Search Users"
                      aria-label=".form-control-sm example"
                      value={searchUsers}
                      onChange={(e) => setSearchUsers(e.target.value)}
                    />
                  </Form>
                </div>
                <CountryDropdown
                  value={selectedCountry}
                  onChange={setSelectedCountry}
                  priorityOptions={["US", "GB", "CA"]}
                  className="w-25 mx-2 border form-control form-control-sm"
                />
              </div>
            </Card.Header>
            {loader ? (
              <div className="mt-5 mb-5 pt-5 pb-5 d-flex justify-content-center text-center align-items-center">
                <Smloader />
              </div>
            ) : (
              <>
                <Card.Body>
                  <div className="table-responsive">
                    <Table bordered hover className="table text-nowrap border">
                      <thead>
                        <tr>
                          <th scope="col">Id</th>
                          <th scope="col">Username</th>
                          <th scope="col">Email</th>
                          <th scope="col">Phone</th>
                          <th scope="col">Country</th>
                          <th scope="col">Status</th>
                        </tr>
                      </thead>
                      <tbody>
                        {users?.map((user, index) => (
                          <tr key={index}>
                            <td>
                              {currentPage === 1
                                ? index + 1
                                : (parseInt(currentPage) - 1) * limit +
                                  index +
                                  1}
                            </td>
                            <td>{user.username}</td>
                            <td>{user.email}</td>
                            <td>
                              {user?.phone?.code} {user?.phone?.phoneCode}{" "}
                              {user?.phone?.number}
                            </td>
                            <td>{user?.phone?.country}</td>
                            <td>{user.status}</td>
                          </tr>
                        ))}
                      </tbody>
                    </Table>
                  </div>
                </Card.Body>
                {totalPages > 0 && (
                  <div className="text-end d-flex justify-content-end ">
                    <nav
                      aria-label="Page navigation"
                      className="pagination-style-1 mx-4"
                    >
                      <PaginationComponent
                        pageNumber={currentPage}
                        setPageNumber={setCurrentPage}
                        totalCount={totalPages}
                      />
                    </nav>
                  </div>
                )}
              </>
            )}
          </Card>
        </Col>
      </Row>
    </>
  );
};

export default UsersScreen;
