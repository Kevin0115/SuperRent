const connection = require('../config/db_config');

exports.test_insert = (req, res) => {
  const query = {
    text: 'INSERT INTO branch VALUES($1, $2, $3, $4, $5)',
    values: [
      6,
      'Main', 
      '1234 Main St.', 
      'Vancouver', 
      5551234
    ]
  }

  connection.query(query)
  .then(queryRes => {
    // console.log(res.rows);
    res.send(queryRes.rows)
  })
  .catch(e => console.error(e.detail))
};

exports.test_select = (req, res) => {
  const query = {
    text: 'SELECT * FROM branch',
  }

  connection.query(query)
  .then(queryRes => {
    // console.log(res.rows);
    res.send(queryRes.rows)
  })
  .catch(e => console.error(e.detail))
};