const connection = require('../config/db_config');
var moment = require('moment');

exports.get_rental = (req, res) => {
    const day = moment().format('YYYY-MM-DD');

    // use these values if you want to test
    // const day = "2019-11-25";
    
    const rental_query = {
      text: `select rid, vlicense, dlicense, from_date, from_time, to_date, to_time, branch_location, branch_city
              from rental r
              where r.from_date = $1::date`,
      values: [day]
    }
  
    connection.query(rental_query)
    .then(result => {
      if (result.rows.length == 0) {
          console.log(result);
        res.send({success: false, content: 'There is no data for selected report. No rentals occured today.'});
      } else {
        res.send({success: true, content: result.rows});
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
    const day = moment().format('YYYY-MM-DD');

    // use these values if you want to test
    // const day = "2019-11-25";
    // const branch_l = "Downtown";
    // const branch_c = "Vancouver";
    
    const rental_query = {
      text: `select rid, vlicense, dlicense, from_date, from_time, to_date, to_time, branch_location, branch_city
              from rental r
              where r.from_date = $1::date
              and r.branch_location = $2
              and r.branch_city = $3`,
      values: [day, branch_l, branch_c]
    }
  
    connection.query(rental_query)
    .then(result => {
      if (result.rows.length == 0) {
        res.send({success: false, content: 'There is no data for selected report. No rentals occured today for provided branch.'});
      } else {
        res.send({success: true, content: result.rows});
      }
    })
    .catch(err => {
      console.error(err);
      res.send({success: false, content: err.detail});
    })
}

exports.get_return = (req, res) => {
    const day = moment().format('YYYY-MM-DD');

    // use these values if you want to test
    // const day = "2019-11-30";
    
    const return_query = {
      text: `select *
              from vehicle_return r
              where r.return_date = $1::date`,
      values: [day]
    }
  
    connection.query(return_query)
    .then(result => {
      if (result.rows.length == 0) {
        res.send({success: false, content: 'There is no data for selected report. No returns occured today.'});
      } else {
        res.send({success: true, content: result.rows});
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
    const day = moment().format('YYYY-MM-DD');

    // use thess values if you want to test
    // const day = "2019-11-30";
    // const branch_l = "Downtown";
    // const branch_c = "Vancouver";
    
    const return_query = {
      text: `select *
              from vehicle_return r
              where r.return_date = $1::date
              and r.branch_location = $2
              and r.branch_city = $3`,
      values: [day, branch_l, branch_c]
    }
  
    connection.query(return_query)
    .then(result => {
      if (result.rows.length == 0) {
        res.send({success: false, content: 'There is no data for selected report. No rentals occured today for the specified branch.'});
      } else {
        res.send({success: true, content: result.rows});
      }
    })
    .catch(err => {
      console.error(err);
      res.send({success: false, content: err.detail});
    })
  }