import { FC, Fragment, useState } from 'react';
import { Button, Card, Col, Dropdown, Pagination, ProgressBar, Row } from 'react-bootstrap';
import { Candidatesdata, Conversionratio, Dealsstatistics, Profit, Profitearned, Revenueanalytics, Totalcustomers, Totaldeals, Totalrevenue } from './crmdata';
import { Link } from 'react-router-dom';
import face10 from "../../../assets/images/faces/10.jpg";
import face12 from "../../../assets/images/faces/12.jpg";


const Crm = () => {
    // for User search function
    const [Data, setData] = useState(Dealsstatistics);

    const userdata = [];

    const myfunction = (idx) => {
        let Data;
        for (Data of Dealsstatistics) {
            if (Data.name[0] == " ") {
                Data.name = Data.name.trim();
            }
            if (Data.name.toLowerCase().includes(idx.toLowerCase())) {
                if (Data.name.toLowerCase().startsWith(idx.toLowerCase())) {
                    userdata.push(Data);
                }
            }

        }
        setData(userdata);
    };
    return (
        <Fragment>

            <div className="d-md-flex d-block align-items-center justify-content-between my-4 page-header-breadcrumb">
                <div>
                    <p className="fw-semibold fs-18 mb-0">Welcome back, Json Taylor !</p>
                    <span className="fs-semibold text-muted">Track your sales activity, leads and deals here.</span>
                </div>
                <div className="btn-list mt-md-0 mt-2">
                    <Button variant='' type="button" className="btn btn-primary btn-wave">
                        <i className="ri-filter-3-fill me-2 align-middle d-inline-block"></i>Filters
                    </Button>
                    <Button variant='' type="button" className="btn btn-outline-secondary btn-wave">
                        <i className="ri-upload-cloud-line me-2 align-middle d-inline-block"></i>Export
                    </Button>
                </div>
            </div>
            <Row>
                <Col xxl={9} xl={12}>
                    <Row>
                        <Col xl={4}>
                            <Row>
                                <Col xl={12}>
                                    <Card className="custom-card crm-highlight-card">
                                        <Card.Body>
                                            <div className="d-flex align-items-center justify-content-between">
                                                <div>
                                                    <div className="fw-semibold fs-18 text-fixed-white mb-2">Your target is incomplete</div>
                                                    <span className="d-block fs-12 text-fixed-white"><span className="op-7">You have completed</span> <span className="fw-semibold text-warning">48%</span> <span className="op-7">of the given target, you can also check your status</span>.</span>
                                                    <span className="d-block fw-semibold mt-1"><Link className="text-fixed-white" to="#"><u>Click here</u></Link></span>
                                                </div>
                                                <div>
                                                    <div id="crm-main">
                                                        <Profit />
                                                    </div>
                                                </div>
                                            </div>
                                        </Card.Body>
                                    </Card>
                                </Col>
                            </Row>
                            <Col xl={12}>
                                <Card className="custom-card">
                                    <Card.Header className="  justify-content-between">
                                        <Card.Title>
                                            Top Deals
                                        </Card.Title>
                                        <Dropdown>
                                            <Dropdown.Toggle variant='' aria-label="anchor" className="btn btn-icon btn-sm btn-light no-caret" data-bs-toggle="dropdown" aria-expanded="false">
                                                <i className="fe fe-more-vertical"></i>
                                            </Dropdown.Toggle>
                                            <Dropdown.Menu align={{sm :'start'}}>
                                                <Dropdown.Item>Week</Dropdown.Item>
                                                <Dropdown.Item>Month</Dropdown.Item>
                                                <Dropdown.Item>Year</Dropdown.Item>
                                            </Dropdown.Menu>
                                        </Dropdown>
                                    </Card.Header>
                                    <Card.Body>
                                        <ul className="list-unstyled crm-top-deals mb-0">
                                            <li>
                                                <div className="d-flex align-items-top flex-wrap">
                                                    <div className="me-2">
                                                        <span className="avatar avatar-sm avatar-rounded">
                                                            <img src={face10} alt="" />
                                                        </span>
                                                    </div>
                                                    <div className="flex-fill">
                                                        <p className="fw-semibold mb-0">Michael Jordan</p>
                                                        <span className="text-muted fs-12">michael.jordan@example.com</span>
                                                    </div>
                                                    <div className="fw-semibold fs-15">$2,893</div>
                                                </div>
                                            </li>
                                            <li>
                                                <div className="d-flex align-items-top flex-wrap">
                                                    <div className="me-2">
                                                        <span className="avatar avatar-sm avatar-rounded bg-warning-transparent fw-semibold">
                                                            EK
                                                        </span>
                                                    </div>
                                                    <div className="flex-fill">
                                                        <p className="fw-semibold mb-0">Emigo Kiaren</p>
                                                        <span className="text-muted fs-12">emigo.kiaren@gmail.com</span>
                                                    </div>
                                                    <div className="fw-semibold fs-15">$4,289</div>
                                                </div>
                                            </li>
                                            <li>
                                                <div className="d-flex align-items-top flex-wrap">
                                                    <div className="me-2">
                                                        <span className="avatar avatar-sm avatar-rounded">
                                                            <img src={face12} alt="" />
                                                        </span>
                                                    </div>
                                                    <div className="flex-fill">
                                                        <p className="fw-semibold mb-0">Randy Origoan</p>
                                                        <span className="text-muted fs-12">randy.origoan@gmail.com</span>
                                                    </div>
                                                    <div className="fw-semibold fs-15">$6,347</div>
                                                </div>
                                            </li>
                                            <li>
                                                <div className="d-flex align-items-top flex-wrap">
                                                    <div className="me-2">
                                                        <span className="avatar avatar-sm avatar-rounded bg-success-transparent fw-semibold">
                                                            GP
                                                        </span>
                                                    </div>
                                                    <div className="flex-fill">
                                                        <p className="fw-semibold mb-0">George Pieterson</p>
                                                        <span className="text-muted fs-12">george.pieterson@gmail.com</span>
                                                    </div>
                                                    <div className="fw-semibold fs-15">$3,894</div>
                                                </div>
                                            </li>
                                            <li>
                                                <div className="d-flex align-items-top flex-wrap">
                                                    <div className="me-2">
                                                        <span className="avatar avatar-sm avatar-rounded bg-primary-transparent fw-semibold">
                                                            KA
                                                        </span>
                                                    </div>
                                                    <div className="flex-fill">
                                                        <p className="fw-semibold mb-0">Kiara Advain</p>
                                                        <span className="text-muted fs-12">kiaraadvain214@gmail.com</span>
                                                    </div>
                                                    <div className="fw-semibold fs-15">$2,679</div>
                                                </div>
                                            </li>
                                        </ul>
                                    </Card.Body>
                                </Card>
                            </Col>
                            <Col xxl={12} xl={12} lg={12} md={12} sm={12} className="col-12">
                                <Card className="custom-card">
                                    <Card.Header className=" justify-content-between">
                                        <Card.Title>Profit Earned</Card.Title>
                                        <Dropdown>
                                            <Dropdown.Toggle variant='' className="p-2 fs-12 text-muted no-caret" data-bs-toggle="dropdown" aria-expanded="false">
                                                View All<i className="ri-arrow-down-s-line align-middle ms-1 d-inline-block"></i>
                                            </Dropdown.Toggle>
                                            <Dropdown.Menu role="menu">
                                                <Dropdown.Item>Today</Dropdown.Item>
                                                <Dropdown.Item>This Week</Dropdown.Item>
                                                <Dropdown.Item>Last Week</Dropdown.Item>
                                            </Dropdown.Menu>
                                        </Dropdown>
                                    </Card.Header>
                                    <Card.Body className="py-0 ps-0">
                                        <div id="crm-profits-earned">
                                            <Profitearned />
                                        </div>
                                    </Card.Body>
                                </Card>
                            </Col>
                        </Col>
                        <Col xl={8} className="col-xl-8">
                            <Row>
                                <Col xxl={6} lg={6} md={6}>
                                    <Card className="custom-card overflow-hidden">
                                        <Card.Body>
                                            <div className="d-flex align-items-top justify-content-between">
                                                <div>
                                                    <span className="avatar avatar-md avatar-rounded bg-primary">
                                                        <i className="ti ti-users fs-16"></i>
                                                    </span>
                                                </div>
                                                <div className="flex-fill ms-3">
                                                    <div className="d-flex align-items-center justify-content-between flex-wrap">
                                                        <div>
                                                            <p className="text-muted mb-0">Total Customers</p>
                                                            <h4 className="fw-semibold mt-1">1,02,890</h4>
                                                        </div>
                                                        <div id="crm-total-customers">
                                                            <Totalcustomers />
                                                        </div>
                                                    </div>
                                                    <div className="d-flex align-items-center justify-content-between mt-1">
                                                        <div>
                                                            <Link className="text-primary" to="#">View All<i className="ti ti-arrow-narrow-right ms-2 fw-semibold d-inline-block"></i></Link>
                                                        </div>
                                                        <div className="text-end">
                                                            <p className="mb-0 text-success fw-semibold">+40%</p>
                                                            <span className="text-muted op-7 fs-11">this month</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </Card.Body>
                                    </Card>
                                </Col>
                                <Col xxl={6} lg={6} md={6} >
                                    <Card className="custom-card overflow-hidden">
                                        <Card.Body>
                                            <div className="d-flex align-items-top justify-content-between">
                                                <div>
                                                    <span className="avatar avatar-md avatar-rounded bg-secondary">
                                                        <i className="ti ti-wallet fs-16"></i>
                                                    </span>
                                                </div>
                                                <div className="flex-fill ms-3">
                                                    <div className="d-flex align-items-center justify-content-between flex-wrap">
                                                        <div>
                                                            <p className="text-muted mb-0">Total Revenue</p>
                                                            <h4 className="fw-semibold mt-1">$56,562</h4>
                                                        </div>
                                                        <div id="crm-total-revenue">
                                                            <Totalrevenue />
                                                        </div>
                                                    </div>
                                                    <div className="d-flex align-items-center justify-content-between mt-1">
                                                        <div>
                                                            <Link className="text-secondary" to="#">View All<i className="ti ti-arrow-narrow-right ms-2 fw-semibold d-inline-block"></i></Link>
                                                        </div>
                                                        <div className="text-end">
                                                            <p className="mb-0 text-success fw-semibold">+25%</p>
                                                            <span className="text-muted op-7 fs-11">this month</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </Card.Body>
                                    </Card>
                                </Col>
                                <Col xxl={6} lg={6} md={6} >
                                    <Card className="custom-card overflow-hidden">
                                        <Card.Body>
                                            <div className="d-flex align-items-top justify-content-between">
                                                <div>
                                                    <span className="avatar avatar-md avatar-rounded bg-success">
                                                        <i className="ti ti-wave-square fs-16"></i>
                                                    </span>
                                                </div>
                                                <div className="flex-fill ms-3">
                                                    <div className="d-flex align-items-center justify-content-between flex-wrap">
                                                        <div>
                                                            <p className="text-muted mb-0">Conversion Ratio</p>
                                                            <h4 className="fw-semibold mt-1">12.08%</h4>
                                                        </div>
                                                        <div id="crm-conversion-ratio">
                                                            <Conversionratio />
                                                        </div>
                                                    </div>
                                                    <div className="d-flex align-items-center justify-content-between mt-1">
                                                        <div>
                                                            <Link className="text-success" to="#">View All<i className="ti ti-arrow-narrow-right ms-2 fw-semibold d-inline-block"></i></Link>
                                                        </div>
                                                        <div className="text-end">
                                                            <p className="mb-0 text-danger fw-semibold">-12%</p>
                                                            <span className="text-muted op-7 fs-11">this month</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </Card.Body>
                                    </Card>
                                </Col>
                                <Col xxl={6} lg={6} md={6} className="col-xxl-6 col-lg-6 col-md-6">
                                    <Card className="custom-card overflow-hidden">
                                        <Card.Body>
                                            <div className="d-flex align-items-top justify-content-between">
                                                <div>
                                                    <span className="avatar avatar-md avatar-rounded bg-warning">
                                                        <i className="ti ti-briefcase fs-16"></i>
                                                    </span>
                                                </div>
                                                <div className="flex-fill ms-3">
                                                    <div className="d-flex align-items-center justify-content-between flex-wrap">
                                                        <div>
                                                            <p className="text-muted mb-0">Total Deals</p>
                                                            <h4 className="fw-semibold mt-1">2,543</h4>
                                                        </div>
                                                        <div id="crm-total-deals">
                                                            <Totaldeals />
                                                        </div>
                                                    </div>
                                                    <div className="d-flex align-items-center justify-content-between mt-1">
                                                        <div>
                                                            <Link className="text-warning" to="#">View All<i className="ti ti-arrow-narrow-right ms-2 fw-semibold d-inline-block"></i></Link>
                                                        </div>
                                                        <div className="text-end">
                                                            <p className="mb-0 text-success fw-semibold">+19%</p>
                                                            <span className="text-muted op-7 fs-11">this month</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </Card.Body>
                                    </Card>
                                </Col>
                                <Col xl={12}>
                                    <Card className="custom-card">
                                        <Card.Header className=" justify-content-between">
                                            <Card.Title>
                                                Revenue Analytics
                                            </Card.Title>
                                            <Dropdown>
                                                <Dropdown.Toggle variant='' className="p-2 fs-12 text-muted no-caret" data-bs-toggle="dropdown"
                                                    aria-expanded="false">
                                                    View All<i className="ri-arrow-down-s-line align-middle ms-1 d-inline-block"></i>
                                                </Dropdown.Toggle>
                                                <Dropdown.Menu role="menu">
                                                    <Dropdown.Item>Today</Dropdown.Item>
                                                    <Dropdown.Item>This Week</Dropdown.Item>
                                                    <Dropdown.Item>Last Week</Dropdown.Item>
                                                </Dropdown.Menu>
                                            </Dropdown>
                                        </Card.Header>
                                        <Card.Body>
                                            <div id="crm-revenue-analytics">
                                                <Revenueanalytics />
                                            </div>
                                        </Card.Body>
                                    </Card>
                                </Col>
                            </Row>
                        </Col>
                        <Col xl={12}>
                            <Card className="custom-card">
                                <Card.Header className=" justify-content-between">
                                    <Card.Title>
                                        Deals Statistics
                                    </Card.Title>
                                    <div className="d-flex flex-wrap gap-2">
                                        <div>
                                            <input className="form-control form-control-sm" type="text" placeholder="Search Here" aria-label=".form-control-sm example" onChange={(ele) => { myfunction(ele.target.value); }} />
                                        </div>
                                        <Dropdown>
                                            <Dropdown.Toggle variant='' className="btn btn-primary btn-sm btn-wave waves-effect waves-light no-caret" data-bs-toggle="dropdown" aria-expanded="false">
                                                Sort By<i className="ri-arrow-down-s-line align-middle ms-1 d-inline-block"></i>
                                            </Dropdown.Toggle>
                                            <Dropdown.Menu>
                                                <Dropdown.Item href="#">New</Dropdown.Item>
                                                <Dropdown.Item href="#">Popular</Dropdown.Item>
                                                <Dropdown.Item href="#">Relevant</Dropdown.Item>
                                            </Dropdown.Menu>
                                        </Dropdown>
                                    </div>
                                </Card.Header>
                                <Card.Body>
                                    <div className="table-responsive">
                                        <table className="table text-nowrap table-hover border table-bordered">
                                            <thead>
                                                <tr>
                                                    <th scope="row" className="ps-4"><input className="form-check-input" type="checkbox" id="checkboxNoLabel1" value="" aria-label="..." /></th>
                                                    <th scope="col">Sales Rep</th>
                                                    <th scope="col">Category</th>
                                                    <th scope="col">Mail</th>
                                                    <th scope="col">Location</th>
                                                    <th scope="col">Date</th>
                                                    <th scope="col">Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {Data.map((idx) => (
                                                    <tr key={Math.random()}>
                                                        <th scope="row" className="ps-4">
                                                            <input className="form-check-input" type="checkbox" id={idx.id} defaultChecked={idx.checked === 'defaultChecked'} value="" aria-label="..." /></th>
                                                        <td>
                                                            <div className="d-flex align-items-center fw-semibold">
                                                                <span className="avatar avatar-sm me-2 avatar-rounded">
                                                                    <img src={idx.src} alt="img" />
                                                                </span>{idx.name}
                                                            </div>
                                                        </td>
                                                        <td>{idx.role}</td>
                                                        <td>{idx.mail}</td>
                                                        <td>
                                                            <span className={`badge bg-${idx.color}`}>{idx.location}</span>
                                                        </td>
                                                        <td>{idx.date}</td>
                                                        <td>
                                                            <div className="hstack gap-2 fs-15">
                                                                <Link aria-label="anchor" to="#" className="btn btn-icon btn-wave waves-effect waves-light btn-sm btn-success-light"><i className="ri-download-2-line"></i></Link>
                                                                <Link aria-label="anchor" to="#" className="btn btn-icon btn-wave waves-effect waves-light btn-sm btn-primary-light"><i className="ri-edit-line"></i></Link>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                    </div>
                                </Card.Body>
                                <Card.Footer className="">
                                    <div className="d-flex align-items-center">
                                        <div>
                                            Showing 5 Entries <i className="bi bi-arrow-right ms-2 fw-semibold"></i>
                                        </div>
                                        <div className="ms-auto">
                                            <nav aria-label="Page navigation" className="pagination-style-4">
                                                <Pagination className="pagination mb-0">
                                                    <Pagination.Item disabled href="#">Prev</Pagination.Item>
                                                    <Pagination.Item active href="#">1</Pagination.Item>
                                                    <Pagination.Item href="#">2</Pagination.Item>
                                                    <Pagination.Item className="pagination-next" href="#">
                                                        next
                                                    </Pagination.Item>
                                                </Pagination>
                                            </nav>
                                        </div>
                                    </div>
                                </Card.Footer>
                            </Card>
                        </Col>
                    </Row>
                </Col>
                <Col xxl={3} xl={12}>
                    <Row>
                        <Col xxl={12} xl={12}>
                            <Row>
                                <Col xxl={12} xl={6}>
                                    <Card className="custom-card">
                                        <Card.Header className=" justify-content-between">
                                            <Card.Title>
                                                Leads By Source
                                            </Card.Title>
                                            <Dropdown>
                                                <Dropdown.Toggle variant='' aria-label="anchor" className="btn btn-icon btn-sm btn-light no-caret" data-bs-toggle="dropdown">
                                                    <i className="fe fe-more-vertical"></i>
                                                </Dropdown.Toggle>
                                                <Dropdown.Menu>
                                                    <Dropdown.Item>Week</Dropdown.Item>
                                                    <Dropdown.Item>Month</Dropdown.Item>
                                                    <Dropdown.Item>Year</Dropdown.Item>
                                                </Dropdown.Menu>
                                            </Dropdown>
                                        </Card.Header>
                                        <Card.Body className=" p-0 overflow-hidden">
                                            <div className="leads-source-chart d-flex align-items-center justify-content-center px-3 pt-4 pb-3">
                                              
                                                <Candidatesdata/>
                                                <div className="lead-source-value">
                                                    <span className="d-block fs-14">Total</span>
                                                    <span className="d-block fs-25 fw-bold">4,145</span>
                                                </div>
                                            </div>
                                            <div className="row row-cols-12 border-top border-block-start-dashed">
                                                <div className="col-6 col-sm p-0">
                                                    <div className="ps-4 py-3 pe-3 text-center border-end border-inline-end-dashed">
                                                        <span className="text-muted fs-12 mb-1 crm-lead-legend mobile d-inline-block">Mobile
                                                        </span>
                                                        <div><span className="fs-16 fw-semibold">1,624</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div className="col-6 col-sm p-0">
                                                    <div className="p-3 text-center border-end border-inline-end-dashed">
                                                        <span className="text-muted fs-12 mb-1 crm-lead-legend desktop d-inline-block">Desktop
                                                        </span>
                                                        <div><span className="fs-16 fw-semibold">1,267</span></div>
                                                    </div>
                                                </div>
                                                <div className="col-6 col-sm p-0">
                                                    <div className="p-3 text-center border-end border-inline-end-dashed">
                                                        <span className="text-muted fs-12 mb-1 crm-lead-legend laptop d-inline-block">Laptop
                                                        </span>
                                                        <div><span className="fs-16 fw-semibold">1,153</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div className="col-6 col-sm p-0">
                                                    <div className="p-3 text-center">
                                                        <span className="text-muted fs-12 mb-1 crm-lead-legend tablet d-inline-block">Tablet
                                                        </span>
                                                        <div><span className="fs-16 fw-semibold">679</span></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </Card.Body>
                                    </Card>
                                </Col>
                                <Col xxl={12} xl={6}>
                                    <Card className="custom-card">
                                        <Card.Header className=" justify-content-between">
                                            <Card.Title>
                                                Deals Status
                                            </Card.Title>
                                            <Dropdown>
                                                <Dropdown.Toggle variant='' className="p-2 fs-12 text-muted no-caret" data-bs-toggle="dropdown" aria-expanded="false">
                                                    View All<i className="ri-arrow-down-s-line align-middle ms-1 d-inline-block"></i>
                                                </Dropdown.Toggle>
                                                <Dropdown.Menu role="menu">
                                                    <Dropdown.Item>Today</Dropdown.Item>
                                                    <Dropdown.Item>This Week</Dropdown.Item>
                                                    <Dropdown.Item>Last Week</Dropdown.Item>
                                                </Dropdown.Menu>

                                            </Dropdown>
                                        </Card.Header>
                                        <Card.Body>
                                            <div className="d-flex align-items-center mb-3">
                                                <h4 className="fw-bold mb-0">4,289</h4>
                                                <div className="ms-2">
                                                    <span className="badge bg-success-transparent">1.02<i className="ri-arrow-up-s-fill align-mmiddle ms-1"></i></span>
                                                    <span className="text-muted ms-1">compared to last week</span>
                                                </div>
                                            </div>
                                            <ProgressBar className="progress-stacked progress-animate progress-xs mb-4" >
                                                <ProgressBar variant="primary" now={21} key={1} />
                                                <ProgressBar variant="info" now={26} key={2} />
                                                <ProgressBar variant="warning" now={35} key={3} />
                                                <ProgressBar variant="success" now={18} key={4} />
                                            </ProgressBar>
                                            <ul className="list-unstyled mb-0 pt-2 crm-deals-status">
                                                <li className="primary">
                                                    <div className="d-flex align-items-center justify-content-between">
                                                        <div>Successful Deals</div>
                                                        <div className="fs-12 text-muted">987 deals</div>
                                                    </div>
                                                </li>
                                                <li className="info">
                                                    <div className="d-flex align-items-center justify-content-between">
                                                        <div>Pending Deals</div>
                                                        <div className="fs-12 text-muted">1,073 deals</div>
                                                    </div>
                                                </li>
                                                <li className="warning">
                                                    <div className="d-flex align-items-center justify-content-between">
                                                        <div>Rejected Deals</div>
                                                        <div className="fs-12 text-muted">1,674 deals</div>
                                                    </div>
                                                </li>
                                                <li className="success">
                                                    <div className="d-flex align-items-center justify-content-between">
                                                        <div>Upcoming Deals</div>
                                                        <div className="fs-12 text-muted">921 deals</div>
                                                    </div>
                                                </li>
                                            </ul>
                                        </Card.Body>
                                    </Card>
                                </Col>
                                <Col xxl={12} xl={6}>
                                    <Card className="custom-card">
                                        <Card.Header className=" justify-content-between">
                                            <Card.Title>
                                                Recent Activity
                                            </Card.Title>
                                            <Dropdown>
                                                <Dropdown.Toggle variant='' className="p-2 fs-12 text-muted no-caret" data-bs-toggle="dropdown"
                                                    aria-expanded="false">
                                                    View All<i className="ri-arrow-down-s-line align-middle ms-1 d-inline-block"></i>
                                                </Dropdown.Toggle>
                                                <Dropdown.Menu role="menu">
                                                    <Dropdown.Item>Today</Dropdown.Item>
                                                    <Dropdown.Item>This Week</Dropdown.Item>
                                                    <Dropdown.Item>Last Week</Dropdown.Item>
                                                </Dropdown.Menu>
                                            </Dropdown>
                                        </Card.Header>
                                        <Card.Body>
                                            <div>
                                                <ul className="list-unstyled mb-0 crm-recent-activity">
                                                    <li className="crm-recent-activity-content">
                                                        <div className="d-flex align-items-top">
                                                            <div className="me-3">
                                                                <span className="avatar avatar-xs bg-primary-transparent avatar-rounded">
                                                                    <i className="bi bi-circle-fill fs-8"></i>
                                                                </span>
                                                            </div>
                                                            <div className="crm-timeline-content">
                                                                <span className="fw-semibold">Update of calendar events &amp;</span><span><Link to="#" className="text-primary fw-semibold"> Added new events in next week.</Link></span>
                                                            </div>
                                                            <div className="flex-fill text-end">
                                                                <span className="d-block text-muted fs-11 op-7">4:45PM</span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li className="crm-recent-activity-content">
                                                        <div className="d-flex align-items-top">
                                                            <div className="me-3">
                                                                <span className="avatar avatar-xs bg-secondary-transparent avatar-rounded">
                                                                    <i className="bi bi-circle-fill fs-8"></i>
                                                                </span>
                                                            </div>
                                                            <div className="crm-timeline-content">
                                                                <span>New theme for <span className="fw-semibold">Spruko Website</span> completed</span>
                                                                <span className="d-block fs-12 text-muted">Lorem ipsum, dolor sit amet.</span>
                                                            </div>
                                                            <div className="flex-fill text-end">
                                                                <span className="d-block text-muted fs-11 op-7">3 hrs</span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li className="crm-recent-activity-content">
                                                        <div className="d-flex align-items-top">
                                                            <div className="me-3">
                                                                <span className="avatar avatar-xs bg-success-transparent avatar-rounded">
                                                                    <i className="bi bi-circle-fill fs-8"></i>
                                                                </span>
                                                            </div>
                                                            <div className="crm-timeline-content">
                                                                <span>Created a <span className="text-success fw-semibold">New Task</span> today <span className="avatar avatar-xs bg-purple-transparent avatar-rounded ms-1"><i className="ri-add-fill text-purple fs-12"></i></span></span>
                                                            </div>
                                                            <div className="flex-fill text-end">
                                                                <span className="d-block text-muted fs-11 op-7">22 hrs</span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li className="crm-recent-activity-content">
                                                        <div className="d-flex align-items-top">
                                                            <div className="me-3">
                                                                <span className="avatar avatar-xs bg-pink-transparent avatar-rounded">
                                                                    <i className="bi bi-circle-fill fs-8"></i>
                                                                </span>
                                                            </div>
                                                            <div className="crm-timeline-content">
                                                                <span>New member <span className="badge bg-pink-transparent">@andreas gurrero</span> added today to AI Summit.</span>
                                                            </div>
                                                            <div className="flex-fill text-end">
                                                                <span className="d-block text-muted fs-11 op-7">Today</span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li className="crm-recent-activity-content">
                                                        <div className="d-flex align-items-top">
                                                            <div className="me-3">
                                                                <span className="avatar avatar-xs bg-warning-transparent avatar-rounded">
                                                                    <i className="bi bi-circle-fill fs-8"></i>
                                                                </span>
                                                            </div>
                                                            <div className="crm-timeline-content">
                                                                <span>32 New people joined summit.</span>
                                                            </div>
                                                            <div className="flex-fill text-end">
                                                                <span className="d-block text-muted fs-11 op-7">22 hrs</span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li className="crm-recent-activity-content">
                                                        <div className="d-flex align-items-top">
                                                            <div className="me-3">
                                                                <span className="avatar avatar-xs bg-info-transparent avatar-rounded">
                                                                    <i className="bi bi-circle-fill fs-8"></i>
                                                                </span>
                                                            </div>
                                                            <div className="crm-timeline-content">
                                                                <span>Neon Tarly added <span className="text-info fw-semibold">Robert Bright</span> to AI summit project.</span>
                                                            </div>
                                                            <div className="flex-fill text-end">
                                                                <span className="d-block text-muted fs-11 op-7">12 hrs</span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li className="crm-recent-activity-content">
                                                        <div className="d-flex align-items-top">
                                                            <div className="me-3">
                                                                <span className="avatar avatar-xs bg-dark-transparent avatar-rounded">
                                                                    <i className="bi bi-circle-fill fs-8"></i>
                                                                </span>
                                                            </div>
                                                            <div className="crm-timeline-content">
                                                                <span>Replied to new support request <i className="ri-checkbox-circle-line text-success fs-16 align-middle"></i></span>
                                                            </div>
                                                            <div className="flex-fill text-end">
                                                                <span className="d-block text-muted fs-11 op-7">4 hrs</span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li className="crm-recent-activity-content">
                                                        <div className="d-flex align-items-top">
                                                            <div className="me-3">
                                                                <span className="avatar avatar-xs bg-purple-transparent avatar-rounded">
                                                                    <i className="bi bi-circle-fill fs-8"></i>
                                                                </span>
                                                            </div>
                                                            <div className="crm-timeline-content">
                                                                <span>Completed documentation of <Link to="#" className="text-purple text-decoration-underline fw-semibold">AI Summit.</Link></span>
                                                            </div>
                                                            <div className="flex-fill text-end">
                                                                <span className="d-block text-muted fs-11 op-7">4 hrs</span>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </ul>
                                            </div>
                                        </Card.Body>
                                    </Card>
                                </Col>
                            </Row>
                        </Col>
                    </Row>
                </Col>
            </Row>
        </Fragment>
    );
};

export default Crm;
