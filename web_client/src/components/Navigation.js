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
} from 'react-bootstrap';

import './Navigation.css';

class Navigation extends React.Component {
  render() {
    return(
      <Router>
        <Navbar bg="dark" variant="dark">
          <Navbar.Brand href="/">
            <img
              src={require('../logo.png')}
              width="90"
              height="30"
              className="d-inline-block align-top"
              alt=" "
            />
            {' SuperRent '}
          </Navbar.Brand>
          <Navbar.Toggle aria-controls="basic-navbar-nav" />
          <Navbar.Collapse id="basic-navbar-nav">
            <Nav className="ml-auto">
              <NavDropdown title={'Change User'} id="collasible-nav-dropdown" drop="left">
                <NavDropdown.Item as={Link} to="/customer">Customer</NavDropdown.Item>
                <NavDropdown.Divider />
                <NavDropdown.Item as={Link} to="/clerk">Clerk</NavDropdown.Item>
              </NavDropdown>
            </Nav>
          </Navbar.Collapse>
        </Navbar>
        <Switch>
          <Route exact path="/">
            <Main />
          </Route>
          <Route path="/customer">
            <Customer />
          </Route>
          <Route path="/clerk">
            <Clerk />
          </Route>
        </Switch>
      </Router>
    );
  }
}

function Customer() {
  return (
    <div>
      <h2>Welcome to the Customer Page</h2>
    </div>
  );
}

function Main() {
  return (
    <div className="main">
      <h2>I am a...</h2>
      <Button
        className="nav-button"
        variant="secondary"
        size="lg"
        href="/customer"
      >
        Customer
      </Button>
      <Button
        className="nav-button"
        variant="secondary"
        size="lg"
        href="/clerk"
      >
        Clerk
      </Button>
    </div>
  );
}

function Clerk() {
  return (
    <div>
      <h2>Welcome to the Clerk Page</h2>
    </div>
  );
}

export default Navigation;