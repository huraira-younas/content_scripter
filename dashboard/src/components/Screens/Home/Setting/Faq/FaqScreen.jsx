import { useSelector } from "react-redux";
import { Fragment, useState } from "react";
import {
  selectGetLoader,
  selectHelpCenter,
} from "../../../../../pages/selectors";
import { Accordion, Button, Card, Col, Row } from "react-bootstrap";
import Empty from "../../../../common/Empty/Empty";
import Pageheader from "../../../../pageheader/pageheader";
import Smloader from "../../../../common/smloader/smloader";

const FaqScreen = ({
  showModal,
  activeButton,
  setActiveButton,
  handleDeleteButtonClick,
}) => {
  const getLoader = useSelector(selectGetLoader);
  const [activeKey, setActiveKey] = useState(null);
  const helpcenter = useSelector(selectHelpCenter);
  const faq = helpcenter?.faq;

  const handleButtonClick = (buttonName) => {
    setActiveButton(buttonName);
    setActiveKey(null);
  };

  const isAllActive = activeButton === "All";

  return (
    <>
      <Pageheader title={"Faq"} heading={"Settings"} active={"Faq"} />
      <Fragment>
        <Row>
          <Col>
            <Card className="custom-card ">
              <Card.Header className="justify-content-between ">
                <Card.Title>Faq:</Card.Title>
              </Card.Header>

              {getLoader ? (
                <div className="mt-5 mb-5 pt-5 pb-5 d-flex justify-content-center text-center align-items-center">
                  <Smloader size={"text-primary spinner-border-md"} />
                </div>
              ) : (
                <>
                  <Card.Header className="d-flex gap-2 ">
                    <Button
                      className={`px-4 rounded-2 custom ${
                        activeButton === "All" ? "" : "bg-white text-primary"
                      }`}
                      onClick={() => handleButtonClick("All")}
                    >
                      All
                    </Button>

                    {faq?.map((category, index) => (
                      <Button
                        key={index}
                        className={`px-4 rounded-2 custom ${
                          activeButton === category.catName
                            ? ""
                            : "bg-white text-primary"
                        }`}
                        onClick={() => handleButtonClick(category.catName)}
                      >
                        {category.catName}
                      </Button>
                    ))}
                    <div>
                      <Button
                        className="btn bg-white text-primary custom btn-wave waves-effect waves-light"
                        onClick={() => showModal({ trigger: "createAll" })}
                      >
                        +
                      </Button>
                    </div>
                  </Card.Header>

                  {!isAllActive && (
                    <div className="p-2 px-4 page-header-breadcrumb d-flex justify-content-between">
                      <div></div>
                      <div>
                        <Button
                          className="text-nowrap btn btn-primary btn-wave waves-effect waves-light"
                          onClick={() => showModal({ trigger: "create" })}
                        >
                          Create {activeButton}
                        </Button>
                      </div>
                    </div>
                  )}

                  <div>
                    {faq?.length > 0 ? (
                      <Row className="p-2 mt-2 gap-2">
                        {faq
                          .flatMap((category) =>
                            activeButton === "All" ||
                            category.catName === activeButton
                              ? category.items
                              : []
                          )
                          .map((item, index) => (
                            <Fragment key={index}>
                              <Col sm={10} lg={isAllActive ? 12 : 10}>
                                <Accordion
                                  activeKey={activeKey}
                                  onSelect={(selectedKey) =>
                                    setActiveKey(selectedKey)
                                  }

                                >
                                  <Accordion.Item eventKey={index}>
                                    <Accordion.Header>
                                      {item.title}
                                    </Accordion.Header>
                                    <Accordion.Body>{item.text}</Accordion.Body>
                                  </Accordion.Item>
                                </Accordion>
                              </Col>
                              <Col>
                                {!isAllActive && (
                                  <div className="d-flex gap-2 ">
                                    <Button
                                      className="btn btn-icon rounded-pill btn-wave "
                                      variant="success-transparent"
                                      onClick={() =>
                                        showModal({
                                          trigger: "update",
                                          title: item.title,
                                          text: item.text,
                                          catName: activeButton,
                                          index,
                                        })
                                      }
                                    >
                                      <i className="ri-edit-fill"></i>
                                    </Button>

                                    <Button
                                      variant="danger-transparent"
                                      className="btn btn-icon rounded-pill btn-wave"
                                      onClick={() =>
                                        handleDeleteButtonClick(
                                          activeButton,
                                          index
                                        )
                                      }
                                    >
                                      <i className="ri-delete-bin-line"></i>
                                    </Button>
                                  </div>
                                )}
                              </Col>
                            </Fragment>
                          ))}
                      </Row>
                    ) : (
                      <Empty message="FAQs data not found" />
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

export default FaqScreen;
