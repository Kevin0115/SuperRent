const connection = require('../config/db_config');

exports.create_customer = (req, res) => {
  const query = {
    text: 'insert into customer values ($1, $2, $3, $4)',
    values: [
      req.body.dlicense,
      req.body.cellphone,
      req.body.name,
      req.body.address
    ]
  }

  connection.query(query)
  .then(queryRes => {
    res.send({success: true, content: 'Successfully Created Customer'});
  })
  .catch(err => {
    console.error(err.detail);
    res.send({success: false, content: err.detail});
  })
}

exports.get_all_customers = (req, res) => {
  const query = {
    text: 'select * from customer'
  }

  connection.query(query)
  .then(queryRes => {
    res.send({success: true, content: queryRes.rows});
  })
  .catch(err => {
    console.error(err.detail);
    res.send({success: false, content: err.detail});
  })
}

exports.get_customer_by_dlicense = (req, res) => {
  const query = {
    text: 'select * from customer where dlicense = $1',
    values: [req.params.dlicense]
  }

  connection.query(query)
  .then(queryRes => {
    if (queryRes.rows.length == 0) {
      res.send({success: false, content: 'No User Found with Specified Driver License'});
    } else {
      res.send({success: true, content: queryRes.rows});
    }
  })
  .catch(err => {
    console.error(err.detail);
    res.send({success: false, content: err.detail});
  })
}

exports.delete_all_customers = (req, res) => {
  const query = {
    text: 'delete from customer where dlicense > 0'
  }

  connection.query(query)
  .then(queryRes => {
    res.send({success: true, content: 'All Customers Deleted'});
  })
  .catch(err => {
    console.error(err.detail);
    res.send({success: false, content: err.detail});
  })
}