import { useSelector } from "react-redux";
import Empty from "../../../../common/Empty/Empty";
import { Fragment, useEffect, useState } from "react";
import {
  selectGetLoader,
  selectHelpCenter,
} from "../../../../../pages/selectors";
import { Accordion, Button, Card, Col, Row } from "react-bootstrap";
import Pageheader from "../../../../pageheader/pageheader";
import Smloader from "../../../../common/smloader/smloader";

const ContactScreen = ({ showModal, showDeleteModal }) => {
  const getLoader = useSelector(selectGetLoader);
  const [activeKey, setActiveKey] = useState(null);
  const [imgLoaders, setImgLoaders] = useState({});
  const helpcenter = useSelector(selectHelpCenter);
  const { contactUs } = helpcenter;

  const toggleAccordion = (index) => {
    if (activeKey === index) {
      setActiveKey(null);
    } else {
      setActiveKey(index);
    }
  };

  useEffect(() => {
    if (contactUs) {
      setImgLoaders((prevLoaders) => {
        const newLoaders = { ...prevLoaders };
        contactUs.forEach((item, index) => {
          if (!(index in newLoaders)) {
            newLoaders[index] = true;
          }
        });
        return newLoaders;
      });
    }
  }, [contactUs]);

  const handleImageLoad = (index) => {
    setImgLoaders((prevLoaders) => ({
      ...prevLoaders,
      [index]: false,
    }));
  };

  return (
    <>
      <Pageheader
        title={"Settings"}
        heading={"Settings"}
        active={"Contact us"}
      />

      <Fragment>
        <Row>
          <Col>
            <Card className="custom-card">
              <Card.Header className="justify-content-between">
                <Card.Title>Contact Us</Card.Title>
                <div>
                  <Button
                    className="btn btn-primary btn-wave waves-effect waves-light"
                    onClick={() => showModal(null, null, null)}
                  >
                    Create
                  </Button>
                </div>
              </Card.Header>

              {getLoader ? (
                <div className="mt-5 mb-5 pt-5 pb-5 d-flex justify-content-center text-center align-items-center">
                  <Smloader />
                </div>
              ) : (
                <>
                  <div>
                    {contactUs?.length > 0 ? (
                      <Row className="p-2 mt-2 gap-2">
                        {contactUs?.map((item, index) => (
                          <Fragment key={index}>
                            <Col xs={12} sm={9} md={10}>
                              <Accordion
                                className="accordion accordions-items-seperate"
                                activeKey={activeKey}
                              >
                                <Accordion.Item
                                  className="accordion accordions-items-seperate"
                                  eventKey={index}
                                  onClick={() => toggleAccordion(index)}
                                >
                                  <Accordion.Header>
                                    <div className="d-flex justify-content-between">
                                      <div className="d-flex align-items-center gap-2">
                                        {imgLoaders[index] && <Smloader />}
                                        <img
                                          src={item.icon}
                                          width={20}
                                          alt="Icon"
                                          style={{
                                            display: imgLoaders[index]
                                              ? "none"
                                              : "inline",
                                            marginRight: "10px",
                                          }}
                                          onLoad={() => handleImageLoad(index)}
                                        />
                                        {item.title}
                                      </div>
                                    </div>
                                  </Accordion.Header>
                                  <Accordion.Body>{item.text}</Accordion.Body>
                                </Accordion.Item>
                              </Accordion>
                            </Col>

                            <Col>
                              <div className="d-flex gap-2 ">
                                <Button
                                  className="btn btn-icon rounded-pill btn-wave "
                                  variant="success-transparent"
                                  onClick={() =>
                                    showModal(
                                      item.icon,
                                      item.title,
                                      item.text,
                                      index
                                    )
                                  }
                                >
                                  <i className="ri-edit-fill"></i>
                                </Button>

                                <Button
                                  variant="danger-transparent"
                                  className="btn btn-icon rounded-pill btn-wave"
                                  onClick={() => showDeleteModal(index)}
                                >
                                  <i className="ri-delete-bin-line"></i>
                                </Button>
                              </div>
                            </Col>
                          </Fragment>
                        ))}
                      </Row>
                    ) : (
                      <Empty message="Contact data not found" />
                    )}
                  </div>
                </>
              )}
            </Card>
          </Col>
        </Row>
      </Fragment>
    </>
  );
};

export default ContactScreen;
