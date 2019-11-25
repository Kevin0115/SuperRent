const connection = require('../config/db_config');
var moment = require('moment');

const UTC_PST_OFFSET = -8;

exports.get_rental = async (req, res) => {
  try {
    const day = moment().utcOffset(UTC_PST_OFFSET).format('YYYY-MM-DD');
  
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
      text: `select r.branch_location, r.branch_city, v.vtname, r.rid, r.vlicense, r.dlicense, r.from_date, r.from_time, r.to_date, r.to_time
              from rental r, vehicle v
              where r.vlicense = v.vlicense
              and r.from_date = $1::date
              order by r.branch_location, r.branch_city, v.vtname`,
      values: [day]
    }
  
    let rentals_per_branch_result = await connection.query(rentals_per_branch_query);
    let rentals_per_category_result = await connection.query(rentals_per_category_query);
    let total_rentals_result = await connection.query(total_rentals_count_query);
    let all_rentals_result = await connection.query(all_rentals_query);
  
    if(total_rentals_result.rows.length == 0) {
      res.send({success: false, content: 'There is no data for selected report. No rentals occured today.'});
    } else {
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
  }
  catch(err){
    console.log(err);
    res.send({success: false, content: err.detail});
  }
}

exports.get_rental_for_branch = async (req, res) => {
  try {
    const branch_l = req.params.branch_location;
    const branch_c = req.params.branch_city;
    const day = moment().utcOffset(UTC_PST_OFFSET).format('YYYY-MM-DD');

    //check for branch existence
     const branch_exists_query = {
        text: `select *
               from branch
               where branch_location like $1
               and branch_city like $2`,
        values: [branch_l, branch_c]
     }
    
    //all rentals for specified branch
    const all_rentals_for_branch_query = {
      text: `select r.branch_location, r.branch_city, v.vtname, r.rid, r.vlicense, r.dlicense, r.from_date, r.from_time, r.to_date, r.to_time
              from rental r, vehicle v
              where r.vlicense = v.vlicense
              and r.from_date = $1::date
              and r.branch_location = $2
              and r.branch_city = $3
              order by v.vtname`,
      values: [day, branch_l, branch_c]
    }

    //number of rentals for specified branch
    const all_rentals_for_branch_count_query = {
      text: `select count(*) as total_rentals_today
              from rental
              where from_date = $1::date
              and branch_location = $2
              and branch_city = $3`,
      values: [day, branch_l, branch_c]
    }

    //rentals for specified branch grouped (and counted) by vehicle category
    const rentals_per_category_query = {
      text: `select v.vtname, count(*) as quantity
              from rental r, vehicle v
              where r.vlicense = v.vlicense
              and r.from_date = $1::date
              and r.branch_location = $2
              and r.branch_city = $3
              group by v.vtname;`,
      values: [day, branch_l, branch_c]
    }

    let branch_exists_result = await connection.query(branch_exists_query);
    let all_rentals_for_branch_result = await connection.query(all_rentals_for_branch_query);
    let all_rentals_for_branch_count_result = await connection.query(all_rentals_for_branch_count_query);
    let rentals_per_category_result = await connection.query(rentals_per_category_query);
  
    if(branch_exists_result.rows.length == 0) { 
      res.send({success: false, content: 'Specified branch does not exist.'});
    } else if (all_rentals_for_branch_count_result.rows.length == 0) {
      res.send({success: false, content: 'There is no data for selected report. No rentals occured today for provided branch.'});
    } else {
      res.send({
        success: true,
        content: {
          branch_all_rentals: all_rentals_for_branch_result.rows,
          branch_total_rentals_count: all_rentals_for_branch_count_result.rows,
          branch_rentals_per_category: rentals_per_category_result.rows,
        }
      });
    }
  }
  catch(err) {
    console.log(err);
    res.send({success: false, content: err.detail});
  }
}

exports.get_return = async (req, res) => {
  try {
    const day = moment().utcOffset(UTC_PST_OFFSET).format('YYYY-MM-DD');
  
    const returns_per_category_query = {
      text: `select v.vtname, count(*) as quantity, sum(r.price) as revenue
              from vehicle_return r, vehicle v
              where r.vlicense = v.vlicense
              and r.return_date = $1::date
              group by v.vtname;`,
      values: [day]
    }
  
    const total_returns_count_query = {
      text: `select count(*) as total_returns_today, sum(price) as total_revenue_today
              from vehicle_return
              where return_date = $1::date`,
      values: [day]
    }
  
    const returns_per_branch_query = {
      text: `select branch_location, branch_city, count(*) as quantity, sum(price) as revenue
              from vehicle_return
              where return_date = $1::date
              group by branch_location, branch_city;`,
      values: [day]
    }
    
    const all_returns_query = {
      text: `select r.branch_location, r.branch_city, v.vtname, r.rid, r.vlicense, r.return_date, r.return_time
              from vehicle_return r, vehicle v
              where r.vlicense = v.vlicense
              and r.return_date = $1::date
              order by r.branch_location, r.branch_city, v.vtname`,
      values: [day]
    }
  
    let returns_per_branch_result = await connection.query(returns_per_branch_query);
    let returns_per_category_result = await connection.query(returns_per_category_query);
    let total_returns_result = await connection.query(total_returns_count_query);
    let all_returns_result = await connection.query(all_returns_query);
  
    if(total_returns_result.rows.length == 0) {
      res.send({success: false, content: 'There is no data for selected report. No returns occured today.'});
    } else {
      res.send({
        success: true,
        content: {
          total_returns_count: total_returns_result.rows,
          returns_per_branch: returns_per_branch_result.rows,
          returns_per_category: returns_per_category_result.rows,
          all_returns: all_returns_result.rows
        }
      });
    }
  }
  catch(err){
    console.log(err);
    res.send({success: false, content: err.detail});
  }
}

exports.get_return_for_branch = async (req, res) => {
  try {
    const branch_l = req.params.branch_location;
    const branch_c = req.params.branch_city;
    const day = moment().utcOffset(UTC_PST_OFFSET).format('YYYY-MM-DD');

    //check for branch existence
    const branch_exists_query = {
      text: `select *
              from branch
              where branch_location like $1
              and branch_city like $2`,
      values: [branch_l, branch_c]
    }

    //all returns for specified branch
    const all_returns_for_branch_query = {
      text: `select r.branch_location, r.branch_city, v.vtname, r.rid, r.vlicense, r.return_date, r.return_time
              from vehicle_return r, vehicle v
              where r.vlicense = v.vlicense
              and r.return_date = $1::date
              and r.branch_location = $2
              and r.branch_city = $3
              order by v.vtname`,
      values: [day, branch_l, branch_c]
    }

    //number of returns for specified branch
    const all_returns_for_branch_count_query = {
      text: `select count(*) as total_returns_today, sum(price) as branch_revenue_today
              from vehicle_return
              where return_date = $1::date
              and branch_location = $2
              and branch_city = $3`,
      values: [day, branch_l, branch_c]
    }

    //returns for specified branch grouped (and counted) by vehicle category
    const returns_per_category_query = {
      text: `select v.vtname, count(*) as quantity, sum(r.price) as revenue
              from vehicle_return r, vehicle v
              where r.vlicense = v.vlicense
              and r.return_date = $1::date
              and r.branch_location = $2
              and r.branch_city = $3
              group by v.vtname;`,
      values: [day, branch_l, branch_c]
    }
    
    let branch_exists_result = await connection.query(branch_exists_query);
    let all_returns_for_branch_result = await connection.query(all_returns_for_branch_query);
    let all_returns_for_branch_count_result = await connection.query(all_returns_for_branch_count_query);
    let returns_per_category_result = await connection.query(returns_per_category_query);
  
    if(branch_exists_result.rows.length == 0) { 
      res.send({success: false, content: 'Specified branch does not exist.'});
    } else if (all_returns_for_branch_count_result.rows.length == 0) {
      res.send({success: false, content: 'There is no data for selected report. No returns occured today for provided branch.'});
    } else {
      res.send({
        success: true,
        content: {
          branch_all_returns: all_returns_for_branch_result.rows,
          branch_total_returns_count: all_returns_for_branch_count_result.rows,
          branch_returns_per_category: returns_per_category_result.rows,
        }
      });
    }
  }
  catch(err) {
    console.log(err);
    res.send({success: false, content: err.detail});
  }
}