import React from 'react';
import {
  Button,
  Form,
  Alert,
  Card,
  Dropdown
} from 'react-bootstrap';
import './Customer.css';

import { formatDate, formatTime, noNullState, calculatePrice, formatDateTime } from '../utils/Utils';
import { API_BASE, POST } from '../utils/Const';
import DatetimeRangePicker from 'react-datetime-range-picker';

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
      branchCity: null,
      confNo: 0,
      // Internal
      size: null,
      type: null,
      showAlert: false,
    }
    this.handleIntervalChange = this.handleIntervalChange.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.handlePickerChange = this.handlePickerChange.bind(this);
    this.updateVtname = this.updateVtname.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.alert = this.alert.bind(this);
  }

  handleChange(e) {
    this.setState({[e.target.name]: e.target.value});
  }

  handlePickerChange(key, value) {
    this.setState({[key]: value}, this.updateVtname);
  }

  updateVtname() {
    if (this.state.size == null || this.state.type == null) {
      return;
    }
    this.setState({
      vtname: this.state.size.toLowerCase() + '_' + this.state.type.toLowerCase()
    });
  }

  handleIntervalChange(e) {
    this.setState({
      fromDate: formatDate(e.start),
      fromTime: formatTime(e.start),
      toDate: formatDate(e.end),
      toTime: formatTime(e.end),
      // price: calculatePrice(e.start, e.end, (h_rate + hi_rate), (d_rate + di_rate), (w_rate + wi_rate)),
    });
  }

  handleSubmit(e) {
    e.preventDefault();
    const { vtname, fromDate, fromTime, toDate, toTime, dlicense, branchLocation, branchCity } = this.state;
    fetch(API_BASE + 'reservation', {
      method: POST,
      headers: {
      'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        vtname: vtname,
        from_date: fromDate,
        from_time: fromTime,
        to_date: toDate,
        to_time: toTime,
        dlicense: dlicense,
        branch_location: branchLocation,
        branch_city: branchCity,
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
      this.alert(false, 'Something went wrong on our end, please try again.');
    })
  }

  alert(success, content) {
    const { fromDate, fromTime, toDate, toTime } = this.state;
    if (success) {
      this.setState({
        showAlert: true,
        alertTitle: 'All Done!',
        alertMessage: 'Your reservation has been successfully created! Confirmation # '
                        + content.conf_no + '\n Estimated Price: $'
                        + calculatePrice(formatDateTime(fromDate, fromTime), formatDateTime(toDate, toTime), content.rate.hourly, content.rate.daily, content.rate.weekly),
        alertColor: 'success',
        confNo: content.conf_no,
      });
    } else {
      this.setState({
        showAlert: true,
        alertTitle: 'Sorry...',
        alertMessage: content,
        alertColor: 'danger'
      });
    }
    setTimeout((() => this.setState({showAlert: false})), 10000);
  }

  clearForm() {
    this.setState({
      vtname: null,
      dlicense: null,
      branchLocation: null,
      branchCity: null,
      size: '',
      type: '',
    });
    this.messageForm.reset();
  }

  render() {
    return(
      <div className="reservation">
        <h2>Create a Reservation</h2>
        <Card bg="primary" text="white" className="note">
          <Card.Body>
            <Card.Text>
              If you'd like to browse and reserve a specific vehicle, please check the 'Vehicles' tab.
            </Card.Text>
          </Card.Body>
        </Card>
        <h3>Please fill this form to complete your reservation.</h3>
        <form className="form" ref={ form => this.messageForm = form } onSubmit={this.handleSubmit}>
          <Form.Group>
            <Form.Label>Branch Location</Form.Label>
            <Form.Control type="text" name="branchLocation" onChange={this.handleChange} placeholder="Downtown" />
          </Form.Group>
          <Form.Group>
            <Form.Label>Branch City</Form.Label>
            <Form.Control type="text" name="branchCity" onChange={this.handleChange} placeholder="Vancouver" />
          </Form.Group>
          <Form.Group>
            <Form.Label>Driver's License Number</Form.Label>
            <Form.Control type="number" name="dlicense" onChange={this.handleChange} placeholder="9999999" />
          </Form.Group>
          <div className="interval-picker">
            <div className="interval-label">
              <p>From</p><p>To</p>
            </div>
            <DatetimeRangePicker
              dateFormat="MMM D, YYYY"
              onChange={this.handleIntervalChange}
            />
          </div>
          <p>Choose your Vehicle Type</p>
          <div className="dropdown-type">
            <Dropdown>
              <Dropdown.Toggle variant="primary" id="dropdown-basic">
                Car Size: {this.state.size}
              </Dropdown.Toggle>
              <Dropdown.Menu>
                <Dropdown.Item name="vtname" onSelect={() => this.handlePickerChange('size', 'Economy')}>Economy</Dropdown.Item>
                <Dropdown.Item name="vtname" onSelect={() => this.handlePickerChange('size', 'Compact')}>Compact</Dropdown.Item>
                <Dropdown.Item name="vtname" onSelect={() => this.handlePickerChange('size', 'Midsize')}>Midsize</Dropdown.Item>
                <Dropdown.Item name="vtname" onSelect={() => this.handlePickerChange('size', 'Standard')}>Standard</Dropdown.Item>
                <Dropdown.Item name="vtname" onSelect={() => this.handlePickerChange('size', 'Fullsize')}>Fullsize</Dropdown.Item>
                <Dropdown.Item name="vtname" onSelect={() => this.handlePickerChange('size', 'SUV')}>SUV</Dropdown.Item>
                <Dropdown.Item name="vtname" onSelect={() => this.handlePickerChange('size', 'Truck')}>Truck</Dropdown.Item>
              </Dropdown.Menu>
            </Dropdown>
            <Dropdown>
              <Dropdown.Toggle variant="primary" id="dropdown-basic">
                Engine Type: {this.state.type}
              </Dropdown.Toggle>
              <Dropdown.Menu>
                <Dropdown.Item name="vtname" onSelect={() => this.handlePickerChange('type', 'Gas')}>Gas</Dropdown.Item>
                <Dropdown.Item name="vtname" onSelect={() => this.handlePickerChange('type', 'Hybrid')}>Hybrid</Dropdown.Item>
                <Dropdown.Item name="vtname" onSelect={() => this.handlePickerChange('type', 'Electric')}>Electric</Dropdown.Item>
              </Dropdown.Menu>
            </Dropdown>
          </div>    
          <Button variant="primary" type="submit" disabled={!noNullState(this.state) || this.state.size === '' || this.state.type === ''}>
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

export default Reservation;