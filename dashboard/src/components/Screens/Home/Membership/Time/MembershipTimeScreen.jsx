import React, { Fragment } from "react";
import { Button, Card, Table } from "react-bootstrap";
import { Link } from "react-router-dom";
import { calculateDays } from "../../../../../utils/utils";
import Pageheader from "../../../../pageheader/pageheader";
import Smloader from "../../../../common/smloader/smloader";
import { useSelector } from "react-redux";
import {  selectMembershipTimeGetLoader } from "../../../../../pages/selectors";

const MembershipTimeScreen = ({
  showModal,
  showDeleteModal,
  membershipTime,
}) => {
  const getLoader = useSelector(selectMembershipTimeGetLoader)
  return (
    <>
      <Pageheader
        title={"Manage plan durations"}
        heading={"Membership"}
        active={"Plan Durations"}
      />
      <Card className="custom-card">
        <Card.Header className="justify-content-between">
          <Card.Title>Durations - {membershipTime.length}</Card.Title>
          <div>
            <Button
              className="btn btn-primary btn-wave waves-effect waves-light"
              onClick={() => showModal(null, null)}
            >
              Create
            </Button>
          </div>
        </Card.Header>
        {getLoader ? (
          <div className="d-flex justify-content-center text-center align-items-center w-100 my-5">
            <Smloader size={"spinner-border-md text-primary"} />
          </div>
        ) : (
          <Table className="table text-nowrap">
            <thead className="table-primary">
              <tr>
                <th scope="col">Duration</th>
                <th scope="col">Discount</th>
                <th scope="col">Action</th>
              </tr>
            </thead>
            <tbody>
              <Fragment>
                {membershipTime?.map((period, innerIndex) => (
                  <tr key={innerIndex}>
                    <td>{calculateDays(period.time)}</td>
                    <td>{period.discount * 100}%</td>
                    <td>
                      <div className="hstack gap-2 fs-15">
                        <Link
                          to="#"
                          className="btn btn-icon btn-sm btn-info-transparent rounded-pill"
                          onClick={() =>
                            showModal(
                              period.time,
                              period.discount * 100,
                              innerIndex
                            )
                          }
                        >
                          <i className="ri-edit-line"></i>
                        </Link>
                        <Link
                          to="#"
                          className="btn btn-icon btn-sm btn-danger-transparent rounded-pill"
                          onClick={() => showDeleteModal(innerIndex)}
                        >
                          <i className="ri-delete-bin-line"></i>
                        </Link>
                      </div>
                    </td>
                  </tr>
                ))}
              </Fragment>
            </tbody>
          </Table>
        )}
      </Card>
    </>
  );
};

export default MembershipTimeScreen;
