import React from 'react';
import {
  Tabs,
  Tab,
  Accordion,
  Card
} from 'react-bootstrap';
import ReactTable from 'react-table';
import 'react-table/react-table.css'
import './Clerk.css';

import { processColumns } from '../utils/Utils';

const data = [{"branch_location":"Downtown","branch_city":"Vancouver","quantity":"1"},{"branch_location":"Midtown","branch_city":"Surrey","quantity":"11"}];

class ReportAll extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      
    }
  }
  render() {
    return (
      <div className="report">
        <Accordion>
          <Card>
            <Accordion.Toggle as={Card.Header} eventKey="0">
              Rental Reports
            </Accordion.Toggle>
            <Accordion.Collapse eventKey="0">
              <div className="table">
                <h3>Rentals by Branch</h3>
                <ReactTable
                  defaultPageSize={10}
                  columns={processColumns(data)}
                  data={data}
                />
              </div>
            </Accordion.Collapse>
          </Card>
          <Card>
            <Accordion.Toggle as={Card.Header} eventKey="1">
              Return Reports
            </Accordion.Toggle>
            <Accordion.Collapse eventKey="1">
              <div className="table">
                <h3>Rentals by Branch</h3>
                <ReactTable
                  defaultPageSize={10}
                  columns={processColumns(data)}
                  data={data}
                />
              </div>
            </Accordion.Collapse>
          </Card>
        </Accordion>
      </div>
    )
  }
}

export default ReportAll;