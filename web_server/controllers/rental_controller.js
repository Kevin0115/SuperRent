const connection = require('../config/db_config');
var moment = require('moment');

const MINUTES_IN_HOUR = 3600;
const MINUTES_IN_WEEK = 2419200;

/**
 * Customer has an existing reservation
 * This means their reservation holds a SPECIFIC vehicle (by vlicense)
 * 
 * Inputs: conf_no, card_name, card_no, exp_date
 * 
 * Check that they are on time for their reservation booking
 * 
 * We will assume the customer came to the CORRECT branch
 */
exports.create_rental_with_reservation = (req, res) => {
  let rid = Math.floor((Math.random() * 9999999) + 1);
  const conf_no = req.params.conf_no;
  const card_name = req.body.card_name;
  const card_no = req.body.card_no;
  const exp_date = req.body.exp_date;
  const dlicense = req.body.dlicense;

  // Check reservation exists AND belongs to the customer present
  const reservation_query = {
    text: `select *
            from reservation
            where conf_no = $1
            and dlicense = $2`,
    values: [conf_no, dlicense]
  }

  connection.query(reservation_query)
  .then(result => {
    if (result.rows.length == 0) {
      res.send({success: false, content: 'No reservation found for this customer with confirmation ID.'});
    } else {
      const reservation = result.rows[0];

      const vlicense = reservation.vlicense;
      const dlicense = reservation.dlicense;
      const from_date = reservation.from_date;
      const from_time = reservation.from_time;
      const to_date = reservation.to_date;
      const to_time = reservation.to_time;
      const branch_location = reservation.branch_location;
      const branch_city = reservation.branch_city;

      // Now that we've pulled the necessary reservation info, look for the odometer
      const odometer_query = {
        text: `select v.odometer
                from vehicle v
                where v.vlicense = $1
                and v.status like 'available'
                and v.branch_location like $7
                and v.branch_city like $8
                and not exists(
                  select *
                  from reservation r
                  where v.vlicense = r.vlicense
                  and r.dlicense <> $6
                  and ($2::date + $3::time, $4::date + $5::time) overlaps (r.from_date + r.from_time, r.to_date + r.to_time)
                )
                and not exists(
                  select *
                  from rental rt
                  where rt.dlicense = $6 and rt.vlicense = $1
                )`,
        values: [vlicense, from_date, from_time, to_date, to_time, dlicense, branch_location, branch_city]
      }

      connection.query(odometer_query)
      .then(result => {
        if (result.rows.length == 0) {
          res.send({success: false, content: 'Vehicle no longer available.'});
        } else {
          const odometer = result.rows[0].odometer;

          // All clear to book rental
          const rental_query = {
            text: `insert into rental
                    values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,'active')`,
            values: [rid,vlicense,dlicense,from_date,from_time,to_date,to_time,
                      odometer,card_name,card_no,exp_date,conf_no,branch_location,branch_city]
          }

          connection.query(rental_query)
          .then(result => {
            const rental_details  = {
              rid: rid,
              vlicense: vlicense,
              dlicense: dlicense,
              from_date: from_date,
              from_time: from_time,
              to_date: to_date,
              to_time: to_time,
              odometer: odometer,
              card_name: card_name,
              card_no: card_no,
              exp_date: exp_date,
              conf_no: conf_no,
              branch_location: branch_location,
              branch_city: branch_city
            };
            res.send({success: true, content: rental_details});
          })
          .catch(err => {
            console.error(err);
            res.send({success: false, content: err.stack});
          })
        }
      })
      .catch(err => {
        console.error(err);
        res.send({success: false, content: err.detail});
      })
    }
  })
  .catch(err => {
    console.error(err);
    res.send({success: false, content: err.detail});
  })
}

/**
 * Customer has no prior reservation
 * This means we have to find a vehicle for them according to desired Vehicle Type
 * 
 * Inputs: vtname, card_name, card_no, exp_date, branch_location, branch_city
 */
exports.create_rental_no_reservation = (req, res) => {
  let rid = Math.floor((Math.random() * 9999999) + 1);
  // RENTAL DETAILS GIVEN BY CLIENT
  const card_name = req.body.card_name;
  const card_no = req.body.card_no;
  const exp_date = req.body.exp_date;
  const dlicense = req.body.dlicense;
  const vtname = req.body.vtname;
  const to_date = req.body.to_date;
  const to_time = req.body.to_time;
  const from_date = moment().format('YYYY-MM-DD');
  const from_time = moment().format('hh:mm:ss');
  const branch_location = req.body.branch_location;
  const branch_city = req.body.branch_city;

  // Validate that the request interval is at least 1 hour or at most 4 weeks
  const from_timestamp = moment(from_date + 'T' + from_time, moment.HTML5_FMT.DATETIME_LOCAL_SECONDS).unix();
  const to_timestamp = moment(to_date + 'T' + to_time, moment.HTML5_FMT.DATETIME_LOCAL_SECONDS).unix();
  if (to_timestamp - from_timestamp < MINUTES_IN_HOUR ||  to_timestamp - from_timestamp > MINUTES_IN_WEEK) {
    res.send({success: false, content: 'Sorry, the rental interval you requested is invalid.'});
    return; // Nothing more to do here.
  }
  // Validate that the starting time for the rental is not in the past
  if (moment(from_date).isBefore(moment(), 'day')) {
    res.send({success: false, content: 'Sorry, you cannot book a rental in the past'});
    return; // Nothing left to do here.
  }

  // First verify that this customer exists in the database
  const customer_query = {
    text: `select *
            from customer
            where dlicense = $1`,
    values: [dlicense]
  }
  connection.query(customer_query)
  .then(result => {
    if (result.rows.length == 0) {
      res.send({success: false, content: 'No customer found for this license number. Please register them.'});
    } else {
      // Look for a vehicle that matches their desired Vehicle Type
      const vehicle_query = {
        text: `select v.vlicense, v.odometer
                from vehicle v
                where v.vtname like $1
                and v.branch_location like $6
                and v.branch_city like $7
                and not exists(
                  select *
                  from reservation r
                  where v.vlicense = r.vlicense
                  and ($2::date + $3::time, $4::date + $5::time) overlaps (r.from_date + r.from_time, r.to_date + r.to_time)
                )
                and not exists(
                  select *
                  from rental rt
                  where v.vlicense = rt.vlicense
                  and ($2::date + $3::time, $4::date + $5::time) overlaps (rt.from_date + rt.from_time, rt.to_date + rt.to_time)
                )
                limit 1`,
        values: [vtname, from_date, from_time, to_date, to_time, branch_location, branch_city]
      }
      connection.query(vehicle_query)
      .then(result => {
        if (result.rows.length == 0) {
          res.send({success: false, content: 'No Vehicles for that type found at this location.'});
        } else {
          const vehicle = result.rows[0];
          const vlicense = vehicle.vlicense;
          const odometer = vehicle.odometer;
          // All clear to book rental
          const rental_query = {
            text: `insert into rental
                  values($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,null,$12,$13,'active')`,
            values: [rid,vlicense,dlicense,from_date,from_time,to_date,to_time,
                      odometer,card_name,card_no,exp_date,branch_location,branch_city]
          }
          connection.query(rental_query)
          .then(result => {
            const rental_details  = {
              rid: rid,
              vlicense: vlicense,
              dlicense: dlicense,
              from_date: from_date,
              from_time: from_time,
              to_date: to_date,
              to_time: to_time,
              odometer: odometer,
              card_name: card_name,
              card_no: card_no,
              exp_date: exp_date,
              branch_location: branch_location,
              branch_city: branch_city
            };
            res.send({success: true, content: rental_details});
          })
          .catch(err => {
            console.error(err);
            res.send({success: false, content: err.stack});
          })
        }
      })
      .catch(err => {
        console.error(err);
        res.send({success: false, content: err.detail});
      })
    }
  })
  .catch(err => {
    console.error(err);
    res.send({success: false, content: err.detail});
  })
}