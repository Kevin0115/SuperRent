import React from 'react';
import {
  Button,
  Form,
  Alert
} from 'react-bootstrap';
import './Clerk.css';

import { API_BASE, POST } from '../utils/Const';
import { noNullState } from '../utils/Utils';

class RentalReservation extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      cardNo: null,
      cardName: null,
      expDate: null,
      dlicense: null,
      confNo: null,
      showAlert: false,
    }
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.alert = this.alert.bind(this);
  }

  handleSubmit(e) {
    e.preventDefault();
    const { cardNo, cardName, expDate, confNo, dlicense } = this.state;
    fetch(API_BASE + 'rental/' + confNo, {
      method: POST,
      headers: {
      'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        card_no: cardNo,
        card_name: cardName,
        exp_date: expDate,
        dlicense: dlicense
      })
    })
    .then(res => res.json())
    .then(json => {
      console.log(json);
      this.alert(json.success, json.content);
      this.clearForm();
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
        alertMessage: 'Rental Successfully Booked.',
        alertColor: 'success'
      });
    } else {
      this.setState({
        showAlert: true,
        alertTitle: 'Sorry...',
        alertMessage: content,
        alertColor: 'danger'
      });
    }
    setTimeout((() => this.setState({showAlert: false})), 3000);
  }

  clearForm() {
    this.setState({
      cardNo: null,
      cardName: null,
      expDate: null,
      dlicense: null,
      confNo: null,
    });
    this.messageForm.reset();
  }

  render() {
    return(
      <div className="rental-reservation">
        <h2>Book a Rental for a Prior Reservation</h2>
        <form className="form" ref={ form => this.messageForm = form } onSubmit={this.handleSubmit}>
          <Form.Group>
            <Form.Label>Reservation Confirmation ID</Form.Label>
            <Form.Control type="number" name="confNo" onChange={this.handleChange} placeholder="9999999" />
          </Form.Group>
          <Form.Group>
            <Form.Label>Driver's License Number</Form.Label>
            <Form.Control type="number" name="dlicense" onChange={this.handleChange} placeholder="9999999" />
          </Form.Group>
          <Form.Group>
            <Form.Label>Name on Credit Card</Form.Label>
            <Form.Control type="text" name="cardName" onChange={this.handleChange} placeholder="John Appleseed"/>
          </Form.Group>
          <Form.Group>
            <Form.Label>Credit Card Number</Form.Label>
            <Form.Control type="number" name="cardNo" onChange={this.handleChange} placeholder="4800888800008888" />
          </Form.Group>
          <Form.Group>
            <Form.Label>Credit Card Expiration Date</Form.Label>
            <Form.Control type="date" name="expDate" onChange={this.handleChange} />
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

export default RentalReservation;