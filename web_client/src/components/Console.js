import React from 'react';
import {
  Button,
  Modal,
  Alert
} from 'react-bootstrap';
import './Clerk.css';

import { API_BASE, DELETE } from '../utils/Const';

class Console extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      showModal: false,
      showAlert: false,
    }
    this.handleDeleteCustomers = this.handleDeleteCustomers.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
    this.handleOpenModal = this.handleOpenModal.bind(this);
  }

  handleCloseModal() {
    this.setState({showModal: false});
  }

  handleOpenModal() {
    this.setState({showModal: true});
  }

  handleDeleteCustomers() {
    fetch(API_BASE + 'customer', {
      method: DELETE,
      headers: {
      'Content-Type': 'application/json'
      },
    })
    .then(res => res.json())
    .then(json => {
      console.log(json);
      this.handleCloseModal();
      this.alert();
    })
    .catch(function(error) {
      console.log('Error posting session: ' + error);
    })
  }

  alert() {
    this.setState({showAlert: true});
    setTimeout((() => this.setState({showAlert: false})), 3000);
  }

  render() {
    return(
      <div className="console">
        <h2>System Administration Console</h2>
        <Button variant="danger" size="lg" onClick={this.handleOpenModal}>Delete All Customers</Button>
        <Modal show={this.state.showModal} onHide={this.handleCloseModal}>
          <Modal.Header closeButton>
            <Modal.Title>Deleting All Customers</Modal.Title>
          </Modal.Header>
          <Modal.Body>Are you sure you want to proceed?</Modal.Body>
          <Modal.Footer>
            <Button variant="secondary" onClick={this.handleCloseModal}>
              Cancel
            </Button>
            <Button variant="danger" onClick={this.handleDeleteCustomers}>
              Delete Customers
            </Button>
          </Modal.Footer>
        </Modal>
        <Alert className="alert" show={this.state.showAlert} variant="warning" onClose={() => this.setState({showAlert: false})} dismissible>
          {'All Customers Successfully Deleted'}
        </Alert>
      </div>
    );
  }
}

export default Console;