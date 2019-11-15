var express = require('express');
var router = express.Router();

var vehicle_controller = require('../controllers/vehicle_controller');

router.post('/', vehicle_controller.get_vehicles_by_param);

module.exports = router;