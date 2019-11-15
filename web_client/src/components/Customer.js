import React from 'react';
import {
  Button,
  Tabs,
  Tab
} from 'react-bootstrap';
import './Customer.css';

import Register from './Register';
import Vehicles from './Vehicles';

class Customer extends React.Component {
  render() {
    return(
      <div className="customer">
        <Tabs defaultActiveKey="vehicles" className="tabs">
          <Tab eventKey="vehicles" title="Vehicles">
            <Vehicles />
          </Tab>
          <Tab eventKey="reserve" title="Reservation">
            <h2>TODO</h2>
          </Tab>
          <Tab eventKey="register" title="Register">
            <Register />
          </Tab>
        </Tabs>
        
      </div>
    );
  }
}

export default Customer;