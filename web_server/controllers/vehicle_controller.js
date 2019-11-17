const connection = require('../config/db_config');

exports.get_vehicles_by_param = (req, res) => {
  // Vehicle Type
  const size = req.body.size.toLowerCase();
  const querySize = size == 'any' ? '%' : size;
  const type = req.body.type.toLowerCase();
  const queryType = type == 'any' ? '%' : type;
  const vtname = querySize + '_' + queryType

  // Interval
  const from_date = req.body.from_date;
  const from_time = req.body.from_time;
  const to_date = req.body.to_date;
  const to_time = req.body.to_time;

  // Location
  let branch_location = '%';
  let branch_city = '%';
  if (req.body.location.toLowerCase() != 'any') {
    branch_location = req.body.location.split(" ")[0];
    branch_city = req.body.location.split(" ")[1];
  }

  const query = {
    text: `select *
    from vehicle v, vehicle_type vt
    where v.vtname like $1
    and v.vtname = vt.vtname
    and v.status like 'available'
    and v.branch_location like $6 and v.branch_city like $7
    and not exists (
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
    )`,
    values: [vtname, from_date, from_time, to_date, to_time, branch_location, branch_city]
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