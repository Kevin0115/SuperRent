const connection = require('../config/db_config');

exports.get_vehicles_by_param = (req, res) => {
  const size = req.body.size.toLowerCase();
  const querySize = size == 'any' ? '%' : size;
  const type = req.body.type.toLowerCase();
  const queryType = type == 'any' ? '%' : type;

  const vtname = querySize + '_' + queryType

  const query = {
    text: `select make, model, year, color
    from vehicle
    where vtname like $1`,
    values: [vtname]
  }

  connection.query(query)
  .then(queryRes => {
    res.send({success: true, content: queryRes.rows});
  })
  .catch(err => {
    console.error(err);
    res.send({success: false, content: err.detail});
  })
}