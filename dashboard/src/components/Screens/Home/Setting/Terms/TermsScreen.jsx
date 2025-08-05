import { Fragment } from "react";
import { useSelector } from "react-redux";
import { Button, Card, Col, Row } from "react-bootstrap";
import Pageheader from "../../../../pageheader/pageheader";
import Smloader from "../../../../common/smloader/smloader";
import {
  selectGetLoader,
  selectUpdateLoader,
} from "../../../../../pages/selectors";
import QuillEditor from "../../../../common/QuillEditor/QuillEditor";

const TermsScreen = ({
  handleValue,
  handleSubmit,
  handleChange,
  originalValue,
}) => {
  const getLoader = useSelector(selectGetLoader);
  const updateLoader = useSelector(selectUpdateLoader);
  const isValueChanged =
    handleValue.termAndServices.trim("") !== originalValue.trim("");

  return (
    <>
      <Pageheader
        title={"Settings"}
        heading={"Settings"}
        active={"Terms & Services"}
      />
      <Fragment>
        <Row>
          <Col xl={12}>
            <Card className="card custom-card">
              <Card.Header>
                <Card.Title className="">Term & Services Editor</Card.Title>
              </Card.Header>
              {getLoader || updateLoader ? (
                <div className="mt-5 mb-5 pt-5 pb-5 d-flex justify-content-center text-center align-items-center">
                  <Smloader />
                </div>
              ) : (
                <Card.Body>
                  <QuillEditor
                    placeholder={"Write something..."}
                    onChange={(value) =>
                      handleChange({
                        target: { name: "termAndServices", value },
                      })
                    }
                    value={handleValue.termAndServices}
                  />
                  <Card.Header className="justify-content-between">
                    <div></div>
                    <div>
                      <Button
                        className="btn btn-primary btn-wave waves-effect waves-light"
                        onClick={handleSubmit}
                        disabled={!isValueChanged}
                      >
                        {updateLoader ? <Smloader /> : "Save"}
                      </Button>
                    </div>
                  </Card.Header>
                </Card.Body>
              )}
            </Card>
          </Col>
        </Row>
      </Fragment>
    </>
  );
};

export default TermsScreen;
