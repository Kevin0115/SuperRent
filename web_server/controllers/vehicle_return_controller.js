const connection = require('../config/db_config');
var moment = require('moment');

exports.create_return = (req, res) => {
  const rid = req.body.rid;
  const vlicense = req.body.vlicense; // Used to check this is the right vehicle for the rental ID
  const odometer = req.body.odometer;
  const fulltank = req.body.fulltank;
  const tank_value = req.body.tank_value;
  const branch_location = req.body.branch_location;
  const branch_city = req.body.branch_city;
  const dlicense = req.body.dlicense;
  // Instantiate return date and time
  const return_date = moment().format('YYYY-MM-DD');
  const return_time = moment().format('hh:mm:ss');

  // Nest three queries; check rid exists; check correct vehicle for rid; then complete the return
  // We need to join rental, vehicle, and vehicle_type in order to retrieve the rates for calculation later
  // I used 'select *' because it looked cleaner than selecting a dozen+ attributes
  const rid_query = {
    text: `select *, r.status
            from rental r, vehicle v, vehicle_type vt
            where r.rid = $1
            and r.vlicense = v.vlicense
            and v.vtname = vt.vtname`,
    values: [rid]
  }

  connection.query(rid_query)
  .then(result => {
    if (result.rows.length == 0) {
      res.send({success: false, content: 'Sorry, we could not find a rental under that ID'});
    } else if (result.rows[0].status == 'complete') {
      res.send({success: false, content: 'Sorry, this rental has already been completed.'});
    } else if (result.rows[0].vlicense != vlicense) {
      res.send({success: false, content: 'Sorry, the returned vehicle is not the correct vehicle for this rental'});
    } else if (result.rows[0].dlicense != dlicense) {
      res.send({success: false, content: 'Sorry, the entered customer is not the owner of this rental.'});
    } else if (result.rows[0].branch_location != branch_location || result.rows[0].branch_city != branch_city) {
      res.send({success: false, content: 'Sorry, this return must be completed at the original branch.'});
    } else {
      // Everything seems legitimate, so continue with the process
      // For now, I'm going to save some important values from this query for the price calculation
      // Time/Date
      const from_date = moment(result.rows[0].from_date).format('YYYY-MM-DD');
      const from_time = result.rows[0].from_time;
      const to_date = moment(result.rows[0].to_date).format('YYYY-MM-DD');
      const to_time = result.rows[0].to_time;
      // Rates
      const hourly_rate = result.rows[0].h_rate + result.rows[0].hi_rate;
      const daily_rate = result.rows[0].d_rate + result.rows[0].di_rate;
      const weekly_rate = result.rows[0].w_rate + result.rows[0].wi_rate;
      
      // First, begin by marking the rental as 'complete'
      const complete_query = {
        text: `update rental
                set status = 'complete'
                where rid = $1`,
        values: [rid]
      }

      connection.query(complete_query)
      .then(result => {
        // Now that the rental status is updated, process the return
        const return_query = {
          text: `insert into vehicle_return
                  values ($1,$2,$3,$4,$5,$6,$7,$8)`,
          values: [rid,return_date,return_time,odometer,fulltank,tank_value,branch_location,branch_city]
        }

        connection.query(return_query)
        .then(result => {
          // Start calculating the final price
          const from_timestamp = moment(from_date + 'T' + from_time, moment.HTML5_FMT.DATETIME_LOCAL_SECONDS);
          let late_fee = 0;
          let cost_struct;
          if (moment(return_date).isAfter(to_date)) {
            // They are late, so charge them a late fee of $50/day
            const diff = moment(return_date).diff(moment(to_date), 'days');
            late_fee = 50 * diff;
          }
          // Some calculation to find the minimum cost for our customers
          const interval_hours = moment().diff(from_timestamp, 'hours');
          const interval_days = interval_hours / 24;
          const interval_weeks = interval_days / 7;
          // We set the costs to MAX to ensure we take the minimum
          // Unless they reach a whole number (hour, day, week) they are not eligble for that rate
          // For example, if you rent for 0.5 weeks, you are not eligible for weekly rate
          let hourly = Number.MAX_SAFE_INTEGER;
          let daily = Number.MAX_SAFE_INTEGER;
          let weekly = Number.MAX_SAFE_INTEGER;
          if (interval_hours >= 1) {
            hourly = interval_hours * hourly_rate;
          }
          if (interval_days >= 1) {
            daily = interval_days * daily_rate;
          }
          if (interval_weeks >= 1) {
            weekly = interval_weeks * weekly_rate;
          }
          const base_price = parseFloat(Math.min(hourly, daily, weekly)).toFixed(2);
          const total_price = parseFloat(base_price + late_fee).toFixed(2);
          // Prepare the cost structure so the customer knows how it was calculated.
          switch (base_price) {
            case (hourly):
              cost_struct = {
                rate_type: 'hourly',
                rate: hourly_rate,
                quantity: interval_hours,
                base_price: base_price,
                late_fee: late_fee,
                total_price: total_price
              }
              break;
            case (daily):
              cost_struct = {
                rate_type: 'daily',
                rate: daily_rate,
                quantity: interval_days,
                base_price: base_price,
                late_fee: late_fee,
                total_price: total_price
              }
              break;
            case (weekly):
              cost_struct = {
                rate_type: 'weekly',
                rate: weekly_rate,
                quantity: interval_weeks,
                base_price: base_price,
                late_fee: late_fee,
                total_price: total_price
              }
              break;
            default:
              cost_struct = {
                rate_type: 'hourly',
                rate: hourly_rate,
                quantity: interval_hours,
                base_price: base_price,
                late_fee: late_fee,
                total_price: total_price
              }
          }
          // Finally, send the details back as response
          res.send({success: true,
            content: {
              rid: rid,
              cost_struct: cost_struct,
              from_datetime: from_timestamp,
              return_datetime: moment(),
            }
          })
        })
        .catch(err => {
          console.error(err);
          res.send({success: false, content: err.detail});
        })
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