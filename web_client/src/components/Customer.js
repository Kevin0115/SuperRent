import React from 'react';
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link,
} from 'react-router-dom';
import {
  Navbar,
  Nav,
  NavDropdown,
  Button,
  Tabs,
  Tab
} from 'react-bootstrap';
import './Customer.css';

import { postSession } from '../utils/Utils';

class Customer extends React.Component {
  render() {
    return(
      <div className="customer">
        <Tabs defaultActiveKey="reserve" className="tabs">
          <Tab eventKey="reserve" title="Make a Reservation">
            <h2>Welcome to the Customer Page</h2>
            <Button variant="secondary" size="lg" onClick={() => postSession()}>PRESS ME TO ADD A RANDOM CUSTOMER</Button>
          </Tab>
          <Tab eventKey="profile" title="Change Contact Info">
            <h2>TODO</h2>
          </Tab>
        </Tabs>
        
      </div>
    );
  }
}

export default Customer;