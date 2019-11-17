import React from 'react';
import {
  Button,
  Form,
  Alert,
} from 'react-bootstrap';
import './Customer.css';

import { API_BASE, GET } from '../utils/Const';
import { noNullState } from '../utils/Utils';

class ViewReservation extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      dlicense: null,
      confNo: null,
      responseStatus: null,
      responseContent: null,
      display: false,
    }
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    // this.clearForm = this.clearForm.bind(this);
  }

  handleChange(e) {
    this.setState({[e.target.name]: e.target.value});
  }

  handleSubmit(e) {
    e.preventDefault();
    const { confNo, dlicense } = this.state;
    fetch(API_BASE + 'reservation/' + confNo + '/' + dlicense, {
      method: GET,
      headers: {
      'Content-Type': 'application/json'
      }
    })
    .then(res => res.json())
    .then(json => {
      console.log(json);
      this.setState({
        responseStatus: json.success,
        responseContent: json.content,
        display: true
      })
      this.clearForm();
    })
    .catch(function(error) {
      console.log(error);
    })
  }

  clearForm() {
    this.setState({
      dlicense: null,
      confNo: null,
    });
    this.messageForm.reset();
  }

  renderResponse() {
    if (!this.state.display) return null;
    if (this.state.responseStatus) {
      return (
        <div>YAY</div>
      );
    } else {
      return (
        <div>{this.state.responseContent}</div>
      );
    }
  }

  render() {
    return(
      <div className="viewcancel">
        <h2>Search for your Reservation</h2>
        <form className="form" ref={ form => this.messageForm = form } onSubmit={this.handleSubmit}>
          <Form.Group>
            <Form.Label>Reservation Confirmation ID</Form.Label>
            <Form.Control type="number" name="confNo" onChange={this.handleChange} placeholder="9999999" />
          </Form.Group>
          <Form.Group>
            <Form.Label>Driver's License Number</Form.Label>
            <Form.Control type="number" name="dlicense" onChange={this.handleChange} placeholder="9090909" />
          </Form.Group>
          <Button variant="primary" type="submit" disabled={this.state.dlicense == null || this.state.confNo == null}>
            Submit
          </Button>
          {this.renderResponse()}
        </form>
      </div>
    );
  }
}

export default ViewReservation;