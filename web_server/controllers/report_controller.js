const connection = require('../config/db_config');
var moment = require('moment');

exports.get_rental = async (req, res) => {
    const day = moment().format('YYYY-MM-DD');

    const rentals_per_category_query = {
      text: `select v.vtname, count(*) as quantity
              from rental r, vehicle v
              where r.vlicense = v.vlicense
              and r.from_date = $1::date
              group by v.vtname;`,
      values: [day]
    }

    const total_rentals_count_query = {
      text: `select count(*) as total_rentals_today
              from rental
              where from_date = $1::date`,
      values: [day]
    }

    const rentals_per_branch_query = {
      text: `select branch_location, branch_city, count(*) as quantity
              from rental
              where from_date = $1::date
              group by branch_location, branch_city;`,
      values: [day]
    }
    
    const all_rentals_query = {
      text: `select rid, vlicense, dlicense, from_date, from_time, to_date, to_time, branch_location, branch_city
              from rental r
              where r.from_date = $1::date
              order by branch_location, branch_city`,
      values: [day]
    }
  
    let rentals_per_branch_result = await connection.query(rentals_per_branch_query);
    let rentals_per_category_result = await connection.query(rentals_per_category_query);
    let total_rentals_result = await connection.query(total_rentals_count_query);
    let all_rentals_result = await connection.query(all_rentals_query);

    res.send({
      success: true,
      content: {
        total_rentals_count: total_rentals_result.rows,
        rentals_per_branch: rentals_per_branch_result.rows,
        rentals_per_category: rentals_per_category_result.rows,
        all_rentals: all_rentals_result.rows
      }
    });
  }

exports.get_rental_for_branch = (req, res) => {
    const branch_l = req.params.branch_location;
    const branch_c = req.params.branch_city;
    const day = moment().format('YYYY-MM-DD');

    
    // const branch_exists_query = {
    //   text: `select *
    //           from branch
    //           where branch_location like $1
    //           and branch_city like $2`,
              
    // }
    
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
    const branch_c = req.params.branch_city;
    const day = moment().format('YYYY-MM-DD');
    
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