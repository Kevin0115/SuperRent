const connection = require('../config/db_config');
var moment = require('moment');

exports.get_rental = (req, res) => {
    const now = moment.now().format().substring(0,11);
    
    const rental_query = {
      text: `select *
              from rental r
              where r.from_date = $1::date`,
      values: [now]
    }
  
    connection.query(rental_query)
    .then(result => {
      if (result.rows.length == 0) {
          //TODO change here
        res.send({success: false, content: ''});
      } else {
          // TODO change here
        res.send({success: true, content: result});
      }
    })
    .catch(err => {
      console.error(err);
      res.send({success: false, content: err.detail});
    })
  }

exports.get_rental_for_branch = (req, res) => {
    const branch_l = req.params.branch_location;
    const branch_c = reg.params.branch_city;
    const now = moment.now().format().substring(0,11);
    
    const rental_query = {
      text: `select *
              from rental r
              where r.from_date = $1::date
              and r.branch_location = $2
              and r.branch_city = $3`,
      values: [now, branch_l, branch_c]
    }
  
    connection.query(rental_query)
    .then(result => {
      if (result.rows.length == 0) {
          //TODO change here
        res.send({success: false, content: ''});
      } else {
          // TODO change here
        res.send({success: true, content: result});
      }
    })
    .catch(err => {
      console.error(err);
      res.send({success: false, content: err.detail});
    })
}

exports.get_return = (req, res) => {
    const now = moment.now().format().substring(0,11);
    
    const rental_query = {
      text: `select *
              from vehicle_return r
              where r.return_date = $1::date`,
      values: [now]
    }
  
    connection.query(rental_query)
    .then(result => {
      if (result.rows.length == 0) {
          //TODO change here
        res.send({success: false, content: ''});
      } else {
          // TODO change here
        res.send({success: true, content: result});
      }
    })
    .catch(err => {
      console.error(err);
      res.send({success: false, content: err.detail});
    })
  }

exports.get_return_for_branch = (req, res) => {
    const branch_l = req.params.branch_location;
    const branch_c = reg.params.branch_city;
    const now = moment.now().format().substring(0,11);
    
    const rental_query = {
      text: `select *
              from vehicle_return r
              where r.return_date = $1::date
              and r.branch_location = $2
              and r.branch_city = $3`,
      values: [now, branch_l, branch_c]
    }
  
    connection.query(rental_query)
    .then(result => {
      if (result.rows.length == 0) {
          //TODO change here
        res.send({success: false, content: ''});
      } else {
          // TODO change here
        res.send({success: true, content: result});
      }
    })
    .catch(err => {
      console.error(err);
      res.send({success: false, content: err.detail});
    })
  }