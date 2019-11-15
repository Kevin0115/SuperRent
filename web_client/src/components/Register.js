import React from 'react';
import {
  Button,
  Form,
  Alert,
} from 'react-bootstrap';
import './Customer.css';

import { API_BASE, POST } from '../utils/Const';
import { registerCustomer } from '../utils/Utils';

class Register extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      // Registration Info
      name: null,
      address: null,
      phone: null,
      dlicense: null,
      // Alert Info
      showAlert: false,
      alertMessage: null,
      alertTitle: null,
      alertColor: null,
    }
    this.handleNameChange = this.handleNameChange.bind(this);
    this.handleAddressChange = this.handleAddressChange.bind(this);
    this.handlePhoneChange = this.handlePhoneChange.bind(this);
    this.handleLicenseChange = this.handleLicenseChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.clearForm = this.clearForm.bind(this);
  }

  handleNameChange(e) {
    this.setState({name: e.target.value});
  }

  handleAddressChange(e) {
    this.setState({address: e.target.value});
  }

  handlePhoneChange(e) {
    this.setState({phone: e.target.value});
  }

  handleLicenseChange(e) {
    this.setState({license: e.target.value});
  }

  handleSubmit(e) {
    e.preventDefault();
    const { name, address, phone, license } = this.state;
    fetch(API_BASE + 'customer', {
      method: POST,
      headers: {
      'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        "dlicense": license,
        "cellphone": phone,
        "name": name,
        "address": address
      })
    })
    .then(res => res.json())
    .then(json => {
      console.log(json);
      this.alert(json.success)
      this.clearForm();
    })
    .catch(function(error) {
      console.log(error);
      this.alert(false);
    })
  }

  alert(success) {
    if (success) {
      this.setState({
        showAlert: true,
        alertTitle: 'Success!',
        alertMessage: 'You have been successfully registered for SuperRent.',
        alertColor: 'success'
      });
    } else {
      this.setState({
        showAlert: true,
        alertTitle: 'Sorry...',
        alertMessage: 'There was an issue processing your registration.',
        alertColor: 'danger'
      });
    }
    setTimeout((() => this.setState({showAlert: false})), 3000);
  }

  clearForm() {
    this.setState({
      name: null,
      address: null,
      phone: null,
      dlicense: null,
    });
    this.messageForm.reset();
  }

  render() {
    return(
      <div className="register">
        <h2>Register for SuperRent</h2>
        <form className="form" ref={ form => this.messageForm = form } onSubmit={this.handleSubmit}>
          <Form.Group>
            <Form.Label>Name</Form.Label>
            <Form.Control type="text" onChange={this.handleNameChange} placeholder="John Appleseed" />
          </Form.Group>
          <Form.Group>
            <Form.Label>Address</Form.Label>
            <Form.Control type="text" onChange={this.handleAddressChange} placeholder="1 Hacker Way" />
          </Form.Group>
          <Form.Group>
            <Form.Label>Phone Number</Form.Label>
            <Form.Control type="number" onChange={this.handlePhoneChange} placeholder="6048882424"/>
          </Form.Group>
          <Form.Group>
            <Form.Label>Driver's License Number</Form.Label>
            <Form.Control type="number" onChange={this.handleLicenseChange} placeholder="9779800" />
          </Form.Group>
          <Button variant="primary" type="submit">
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

export default Register;