import React from 'react';
import {
  Button,
  Card,
  Badge,
  Alert
} from 'react-bootstrap';
import './Vehicles.css';

import { API_BASE, POST } from '../utils/Const';
import VehicleFilters from './VehicleFilters';
import ReservationModal from './ReservationModal';

import { formatDate, formatTime } from '../utils/Utils';

class Vehicles extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      filters: {
        carSize: 'Any',
        carType: 'Any',
        location: 'Any',
        fromDate: formatDate(new Date()),
        fromTime: formatTime(new Date()),
        toDate: formatDate(new Date()),
        toTime: formatTime(new Date()),
      },
      vehicles: [],
      showModal: false,
      showAlert: false,
      alertMessage: '',
      alertTitle: '',
      alertColor: 'success',
      confNo: null,
      reservationProps: {},
      reservationInfo: {
        vtname: null,
        vlicense: null,
        dlicense: null,
        from_date: null,
        from_time: null,
        to_date: null,
        to_time: null,
        branch_location: null,
        branch_city: null
      }
    }
    this.filterCallback = this.filterCallback.bind(this);
    this.getVehicles = this.getVehicles.bind(this);
    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
    this.reserveCallback = this.reserveCallback.bind(this);
    this.renderAlert = this.renderAlert.bind(this);
  }

  componentDidMount() {
    this.getVehicles();
  }

  getVehicles() {
    const { carSize, carType, location, fromDate, fromTime, toDate, toTime } = this.state.filters;

    fetch(API_BASE + 'vehicle', {
      method: POST,
      headers: {
      'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        size: carSize,
        type: carType,
        location: location,
        from_date: fromDate,
        from_time: fromTime,
        to_date: toDate,
        to_time: toTime
      })
    })
    .then(res => res.json())
    .then(json => {
      this.setState({vehicles: json.content})
    })
    .catch(function(error) {
      console.log(error);
    })
  }

  filterCallback(options) {
    this.setState({
      filters: options
    },
    this.getVehicles);
  }

  handleOpenModal(vehicle) {
    this.setState({
      showModal: true,
      reservationProps: {
        ...vehicle,
        ...this.state.filters
      },
      // Prepare the reservation state
      reservationInfo: {
        vtname: vehicle.vtname,
        vlicense: vehicle.vlicense,
        dlicense: null,
        from_date: null,
        from_time: null,
        to_date: null,
        to_time: null,
        branch_location: vehicle.branch_location,
        branch_city: vehicle.branch_city
      }
    });
  }

  handleCloseModal() {
    this.setState({showModal: false});
  }

  reserveCallback(options) {
    const { vlicense, vtname, branch_city, branch_location } = this.state.reservationInfo;

    this.setState({
      reservationInfo: {
        dlicense: options.dlicense,
        from_date: options.fromDate,
        from_time: options.fromTime,
        to_date: options.toDate,
        to_time: options.toTime,
        vtname,
        vlicense,
        branch_location,
        branch_city
      }
    },
    this.createReservation)
  }

  createReservation() {
    const { vlicense, vtname, dlicense, from_date, from_time, to_date, to_time, branch_city, branch_location } = this.state.reservationInfo;

    fetch(API_BASE + 'reservation', {
      method: POST,
      headers: {
      'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        vtname: vtname,
        vlicense: vlicense,
        dlicense: dlicense,
        from_date: from_date,
        from_time: from_time,
        to_date: to_date,
        to_time: to_time,
        branch_location: branch_location,
        branch_city: branch_city
      })
    })
    .then(res => res.json())
    .then(json => {
      if (json.success) {
        this.setState({
          alertTitle: 'All Done!',
          alertMessage: 'Your reservation has been successfully created! Confirmation #',
          alertColor: 'success',
          showAlert: true,
          showModal: false,
          confNo: json.content,
        },
        this.getVehicles)
      } else {
        this.setState({
          alertTitle: 'Something went wrong.',
          alertMessage: json.content,
          alertColor: 'danger',
          showAlert: true,
          showModal: false,
          confNo: null,
        })
      }
      setTimeout((() => this.setState({showAlert: false})), 10000);
    })
    .catch(function(error) {
      console.log(error);
    })
  }

  renderVehicles() {
    if (this.state.vehicles.length < 1) {
      return (
        <div>
          <h3 className="sorry">
            Sorry, we didn't find any results. Try changing your filters.
          </h3>
        </div>
      );
    }
    return this.state.vehicles.map((item, index) => {
      return(
        <Card className="vehicle-card" key={index}>
          <Card.Header as="h5">Featured</Card.Header>
          <Card.Body>
            <Card.Title>{item.year + ' ' + item.make + ' ' + item.model}</Card.Title>
            <Card.Text>
              Location: {item.branch_location + ' ' + item.branch_city}
            </Card.Text>
            <Button variant="primary" onClick={() => this.handleOpenModal(item)}>Rent me Now!</Button>
          </Card.Body>
        </Card>
      );
    });
  }

  renderAlert() {
    if (this.state.showAlert) {
      return(
        <Alert variant={this.state.alertColor} onClose={() => this.setState({showAlert: false})} dismissible>
          <Alert.Heading>{this.state.alertTitle}</Alert.Heading>
          <p>{this.state.alertMessage} {this.state.confNo}</p>
        </Alert>
      );
    }
  }

  render() {
    return(
      <div className="vehicles">
        <h2>Browse Vehicles</h2>
        <VehicleFilters handler={this.filterCallback} />
        <h2><Badge variant="secondary">Results Found: {this.state.vehicles.length}</Badge></h2>
        <div className="vehicle-list">
          {this.renderVehicles()}
        </div>
        <ReservationModal
          showModal={this.state.showModal}
          reservationProps={this.state.reservationProps}
          handleCloseModal={this.handleCloseModal}
          handler={this.reserveCallback} 
          renderAlert={this.renderAlert}
        />
        {this.renderAlert()}
      </div>
    );
  }
}

export default Vehicles;