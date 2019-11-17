const connection = require('../config/db_config');
var moment = require('moment');

const MINUTES_IN_HOUR = 3600;
const MINUTES_IN_WEEK = 2419200;

exports.create_reservation = async (req, res) => {
  // Ensure no conf_no collision
  let conf_no = Math.floor((Math.random() * 9999999) + 1);
  // Location Details - THESE ARE GUARANTEED TO BE FILLED
  const branch_location = req.body.branch_location;
  const branch_city = req.body.branch_city;
  // Time period - THESE ARE GUARANTEED TO BE FILLED
  const from_date = req.body.from_date;
  const from_time = req.body.from_time;
  const to_date = req.body.to_date;
  const to_time = req.body.to_time;
  // Validate that the request interval is at least 1 hour or at most 4 weeks
  const from_timestamp = moment(from_date + 'T' + from_time, moment.HTML5_FMT.DATETIME_LOCAL_SECONDS).unix();
  const to_timestamp = moment(to_date + 'T' + to_time, moment.HTML5_FMT.DATETIME_LOCAL_SECONDS).unix();
  if (to_timestamp - from_timestamp < MINUTES_IN_HOUR ||  to_timestamp - from_timestamp > MINUTES_IN_WEEK) {
    res.send({success: false, content: 'Sorry, the reservation interval you requested is invalid.'});
    return; // Nothing more to do here.
  }
  // Validate that the starting time for the reservation is not before today
  if (moment(from_date).isBefore(moment(), 'day')) {
    res.send({success: false, content: 'Sorry, you cannot book a reservation in the past'});
    return; // Nothing left to do here.
  }
  // Vehicle Details
  const vtname = req.body.vtname;
  let vlicense = req.body.vlicense;
  // Client Details - Make them register if they're not already
  const dlicense = req.body.dlicense;
  const license_query = {
    text: `select * from customer where dlicense = $1`,
    values: [dlicense]
  }
  connection.query(license_query)
  .then(result => {
    if (result.rows.length == 0) {
      res.send({success: false, content: 'You appear to be new! Please press the \'Register\' tab and register your information with us.'});
    } else {
      // Valid customer, so start querying their request
      // Ensure customer is not overlapping reservations
      const overlap_query = {
        text: `select *
                from reservation r
                where r.dlicense = $1
                and ($2::date + $3::time, $4::date + $5::time) overlaps (r.from_date + r.from_time, r.to_date + r.to_time)`,
        values: [dlicense, from_date, from_time, to_date, to_time]
      }
      connection.query(overlap_query)
      .then(result => {
        if (result.rows.length >= 1) {
          res.send({success: false, content: 'Sorry, you cannnot make reservations that overlap!'});
        } else {
          // Customer has opted to rent any vehicle of type 'vtname', so find one
          if (vlicense == null) {
            // Look for the first available vehicle per the request vtname and branch
            // By available, we mean it doesn't clash with any other reservations during that interval
            const vehicle_query = {
              text: `select v.vlicense
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
                res.send({success: false, content: 'No vehicles for selected vehicle type found at this location during reservation interval.'});
              } else {
                const vlicense = result.rows[0].vlicense;
                // We've found a suitable vehicle. Make a reservation for it
                const reservation_query = {
                  text: `insert into reservation
                        values($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)`,
                  values: [conf_no, vlicense, vtname, dlicense, from_date, from_time, to_date, to_time, branch_location, branch_city]
                }
                connection.query(reservation_query)
                .then(result => {
                  const reservation_details  = {
                    vlicense: vlicense,
                    from_date: from_date,
                    from_time: from_time,
                    to_date: to_date,
                    to_time: to_time,
                    conf_no: conf_no,
                    branch_location: branch_location,
                    branch_city: branch_city
                  };
                  res.send({success: true, content: reservation_details});
                })
                .catch(err => {
                  console.error(err);
                  res.send({success: false, content: err.detail});
                });
              }
            })
            .catch(err => {
              console.error(err);
              res.send({success: false, content: err.detail});
            });
          } else {
            // This time, we check if the selected vehicle is indeed free during their interval
            // This is checked ONLY because the user could have browsed with no interval selected
            // and chosen this car; but to create a reservation, they specified an interval that
            // clashed with another reservation, so this check is yet again necessary.
            const vehicle_query = {
              text: `select *
                      from vehicle v
                      where v.vlicense = $1
                      and not exists(
                        select *
                        from reservation r
                        where v.vlicense = r.vlicense
                        and ($2::date + $3::time, $4::date + $5::time) overlaps (r.from_date + r.from_time, r.to_date + r.to_time)
                      )
                      limit 1`,
              values: [vlicense, from_date, from_time, to_date, to_time]
            }
            connection.query(vehicle_query)
            .then(result => {
              if (result.rows.length == 0) {
                res.send({success: false, content: 'Sorry, this vehicle is reserved during your desired interval. Please browse vehicles using the date interval filter.'});
              } else {
                const reservation_query = {
                  text: `insert into reservation
                        values($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)`,
                  values: [conf_no, vlicense, vtname, dlicense, from_date, from_time, to_date, to_time, branch_location, branch_city]
                }
                connection.query(reservation_query)
                .then(result => {
                  const reservation_details  = {
                    vlicense: vlicense,
                    from_date: from_date,
                    from_time: from_time,
                    to_date: to_date,
                    to_time: to_time,
                    conf_no: conf_no,
                    branch_location: branch_location,
                    branch_city: branch_city
                  };
                  res.send({success: true, content: reservation_details});
                })
                .catch(err => {
                  console.error(err);
                  res.send({success: false, content: err.detail});
                });
              }
            })
            .catch(err => {
              console.error(err);
              res.send({success: false, content: err.detail});
            });
          }
        }
      })
      .catch(err => {
        console.error(err);
        res.send({success: false, content: err.detail});
      });
    }
  })
  .catch(err => {
    console.error(err);
    res.send({success: false, content: err.detail});
  });
}

exports.get_reservation = (req, res) => {
  const dlicense = req.params.dlicense;
  const conf_no = req.params.conf_no;

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
      res.send({success: false, content: 'No reservation found for given Confirmation ID and Driver License #'});
    } else {
      res.send({success: true, content: result.rows});
    }
  })
  .catch(err => {
    console.error(err);
    res.send({success: false, content: err.detail});
  })
}

exports.cancel_reservation = (req, res) => {
  const dlicense = req.params.dlicense;
  const conf_no = req.params.conf_no;

  const reservation_query = {
    text: `delete
            from reservation
            where conf_no = $1
            and dlicense = $2`,
    values: [conf_no, dlicense]
  }

  connection.query(reservation_query)
  .then(result => {
    if (result.rowCount < 1) {
      res.send({success: false, content: 'No reservation found for given Confirmation ID and Driver License #'});
    } else {
      res.send({success: true, content: 'Your reservation has successfully been cancelled'});
    }
  })
  .catch(err => {
    console.error(err);
    res.send({success: false, content: err.detail});
  })
}