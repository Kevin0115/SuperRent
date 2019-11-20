import React from 'react';
import {
  Button,
  Form,
  Alert,
  Card,
  Dropdown
} from 'react-bootstrap';
import './Clerk.css';

import { formatDate, formatTime, noNullState, calculatePrice, formatDateTime } from '../utils/Utils';
import { API_BASE, POST } from '../utils/Const';

class Return extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      rid: null,
      dlicense: null,
      vlicense: null,
      branchLocation: null,
      branchCity: null,
      odometer: null,
      fulltank: null,
      tankValue: null,
      showAlert: false,
    }
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(e) {
    e.preventDefault();
    const { rid, dlicense, vlicense, branchCity, branchLocation, odometer, fulltank, tankValue } = this.state;
    fetch(API_BASE + 'return', {
      method: POST,
      headers: {
      'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        rid: rid,
        dlicense: dlicense,
        vlicense: vlicense,
        branch_location: branchLocation,
        branch_city: branchCity,
        odometer: odometer,
        fulltank: fulltank,
        tank_value: tankValue,
      })
    })
    .then(res => res.json())
    .then(json => {
      console.log(json);
      this.alert(json.success, json.content);
      // this.clearForm();
    })
    .catch(function(error) {
      console.log(error);
      this.alert(false);
    })
  }

  handleChange(e) {
    this.setState({[e.target.name]: e.target.value});
  }

  alert(success, content) {
    if (success) {
      this.setState({
        showAlert: true,
        alertTitle: 'Success!',
        alertMessage: 'Your final price is $' + content.cost_struct.total_price,
        alertColor: 'success'
      });
    } else {
      this.setState({
        showAlert: true,
        alertTitle: 'Error',
        alertMessage: content,
        alertColor: 'danger'
      });
    }
    setTimeout((() => this.setState({showAlert: false})), 10000);
  }

  clearForm() {
    this.setState({
      rid: null,
      dlicense: null,
      vlicense: null,
      branchLocation: null,
      branchCity: null,
      odometer: null,
      fulltank: null,
      tankValue: null,
    });
    this.messageForm.reset();
  }

  render() {
    return(
      <div className="return">
        <h2>Complete a Vehicle Return</h2>
        <form className="form" ref={ form => this.messageForm = form } onSubmit={this.handleSubmit}>
          <Form.Group>
            <Form.Label>Rental ID</Form.Label>
            <Form.Control type="number" name="rid" onChange={this.handleChange} placeholder="9999999" />
          </Form.Group>
          <Form.Group>
            <Form.Label>Driver's License Number</Form.Label>
            <Form.Control type="number" name="dlicense" onChange={this.handleChange} placeholder="9999999" />
          </Form.Group>
          <Form.Group>
            <Form.Label>Vehicle License Number</Form.Label>
            <Form.Control type="number" name="vlicense" onChange={this.handleChange} placeholder="9999999" />
          </Form.Group>
          <Form.Group>
            <Form.Label>Full Tank?</Form.Label>
            <Form.Control type="boolean" name="fulltank" onChange={this.handleChange} placeholder="true" />
          </Form.Group>
          <Form.Group>
            <Form.Label>Tank Value</Form.Label>
            <Form.Control type="number" name="tankValue" onChange={this.handleChange} placeholder="30" />
          </Form.Group>
          <Form.Group>
            <Form.Label>Odometer</Form.Label>
            <Form.Control type="number" name="odometer" onChange={this.handleChange} placeholder="130000" />
          </Form.Group>
          <Form.Group>
            <Form.Label>Branch Location</Form.Label>
            <Form.Control type="text" name="branchLocation" onChange={this.handleChange} placeholder="Downtown"/>
          </Form.Group>
          <Form.Group>
            <Form.Label>Branch City</Form.Label>
            <Form.Control type="text" name="branchCity" onChange={this.handleChange} placeholder="Vancouver"/>
          </Form.Group>
          <Button variant="primary" type="submit" disabled={!noNullState(this.state)}>
            Submit
          </Button>
        </form>
        <Alert className="alert" show={this.state.showAlert} variant={this.state.alertColor} onClose={() => this.setState({showAlert: false})} dismissible>
          <Alert.Heading>{this.state.alertTitle}</Alert.Heading>
          <p>{this.state.alertMessage}</p>
        </Alert>
      </div>
    );
  }
}

export default Return;