import React from 'react';
import {
  Tabs,
  Tab
} from 'react-bootstrap';
import './Clerk.css';

import RentalReservation from './RentalReservation';
import RentalNoReservation from './RentalNoReservation';
import Return from './Return';
import Console from './Console';

class Clerk extends React.Component {
  render() {
    return(
      <div className="clerk">
        <Tabs defaultActiveKey="rental" className="tabs">
          <Tab eventKey="rental" title="Rental (no Reservation)" className="tab">
            <RentalNoReservation />
          </Tab>
          <Tab eventKey="rental-reservation" title="Rental (with Reservation)" className="tab">
            <RentalReservation />
          </Tab>
          <Tab eventKey="return" title="Return">
            <Return />
          </Tab>
          <Tab eventKey="report" title="Report">
            <h2>TODO</h2>
          </Tab>
          <Tab eventKey="console" title="Console">
            <Console />
          </Tab>
        </Tabs>
      </div>
    );
  }
}

export default Clerk;