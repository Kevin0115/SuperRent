const connection = require('../config/db_config');
const fs = require('fs');

const master_query = fs.readFileSync(__dirname + '/../master.sql').toString();

exports.reset_database = (req, res) => {
  const query = {
    text: master_query
  }

  connection.query(query)
  .then(result => {
    res.send({success: true, content: 'Database Reset.'});
  })
  .catch(err => {
    console.error(err.detail);
    res.send({success: false, content: err.detail});
  })
}

exports.delete_r = async (req, res) => {
  const query_1 = {
    text: `delete from reservation where true;`
  }

  const query_2 = {
    text: `delete from rental where true;`
  }

  const query_3 = {
    text: `delete from vehicle_return where true;`
  }

  let res_3 = await connection.query(query_3);
  let res_2 = await connection.query(query_2);
  let res_1 = await connection.query(query_1);

  res.send({success: true, content: 'All Reservations/Rentals/Returns Deleted.'})
}