import React from 'react';
import {
  Button,
  Form,
  Alert,
  Card,
} from 'react-bootstrap';
import './Customer.css';

class Reservation extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      vtname: null,
      fromDate: null,
      fromTime: null,
      toDate: null,
      toTime: null,
      dlicense: null,
      branchLocation: null,
      branchCity: null
    }
  }
  render() {
    return(
      <div className="reservation">
        <h2>Create a Reservation</h2>
        <Card bg="primary" text="white" className="note">
          <Card.Body>
            <Card.Text>
              If you'd like to browse our vehicles and reserve a specific vehicle, you can check the 'Vehicles' tab.
            </Card.Text>
          </Card.Body>
        </Card>
      </div>
    );
  }
}

export default Reservation;