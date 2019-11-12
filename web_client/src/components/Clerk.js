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
import './Clerk.css';

import { postSession } from '../utils/Utils.js';

class Clerk extends React.Component {
  render() {
    return(
      <div className="clerk">
        <Tabs defaultActiveKey="rental" className="tabs">
          <Tab eventKey="rental" title="Rental" className="tab">
            <h2>TODO</h2>
          </Tab>
          <Tab eventKey="return" title="Return">
            <h2>TODO</h2>
          </Tab>
          <Tab eventKey="report" title="Report">
            <h2>TODO</h2>
          </Tab>
        </Tabs>
      </div>
    );
  }
}

export default Clerk;