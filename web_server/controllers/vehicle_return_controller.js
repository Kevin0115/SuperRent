const connection = require('../config/db_config');
var moment = require('moment');

exports.create_return = (req, res) => {
  const rid = req.body.rid;
  const vlicense = req.body.rid; // Used to check this is the right vehicle for the rental ID
  const odometer = req.body.odometer;
  const fulltank = req.body.fulltank;
  const tank_value = req.body.tank_value;
  const branch_location = req.body.branch_location;
  const branch_city = req.body.branch_city;
  const dlicense = req.body.dlicense;

  // Nest three queries; check rid exists; check correct vehicle for rid; then complete the return
  const rid_query = {
    text: `select rid, vlicense, branch_location, branch_city, dlicense, status
            from rental
            where rid = $1`,
    values: [rid]
  }

  connection.query(rid_query)
  .then(result => {
    if (result.rows.length == 0) {
      res.send({success: false, content: 'Sorry, we could not find a rental under that ID'});
    } else if (result.vlicense != vlicense) {
      res.send({success: false, content: 'Sorry, the returned vehicle is not the correct vehicle for this rental'});
    }
  })
  .catch(err => {
    console.error(err);
    res.send({success: false, content: err.detail});
  })
}