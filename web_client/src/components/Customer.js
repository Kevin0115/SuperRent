import React from 'react';
import {
  Button,
  Tabs,
  Tab
} from 'react-bootstrap';
import './Customer.css';

import { postSession } from '../utils/Utils';

import Register from './Register';

class Customer extends React.Component {
  render() {
    return(
      <div className="customer">
        <Tabs defaultActiveKey="reserve" className="tabs">
          <Tab eventKey="vehicles" title="Vehicles">
            <h2>TODO</h2>
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