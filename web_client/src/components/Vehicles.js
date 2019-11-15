import React from 'react';
import {
  Button,
  Tabs,
  Tab,
  Dropdown,
  Card
} from 'react-bootstrap';
import './Vehicles.css';

import { API_BASE, POST } from '../utils/Const';
import VehicleFilters from './VehicleFilters';

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
      vehicles: []
    }
    this.filterCallback = this.filterCallback.bind(this);
    this.getVehicles = this.getVehicles.bind(this);
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

  renderVehicles() {
    if (this.state.vehicles.length < 1) {
      return 'Sorry, No Results Found!';
    }
    return this.state.vehicles.map((item, index) => {
      return(
        <Card className="vehicle-card" key={index}>
          <Card.Header as="h5">Featured</Card.Header>
          <Card.Body>
            <Card.Title>{item.year + ' ' + item.make + ' ' + item.model}</Card.Title>
            <Card.Text>
              Additional Information.
            </Card.Text>
            <Button variant="primary">Rent me Now!</Button>
          </Card.Body>
        </Card>
      );
    });
  }

  render() {
    return(
      <div className="vehicles">
        <h2>Browse Vehicles</h2>
        <VehicleFilters handler={this.filterCallback} />
        <div className="vehicle-list">
          {this.renderVehicles()}
        </div>
      </div>
    );
  }
}

export default Vehicles;