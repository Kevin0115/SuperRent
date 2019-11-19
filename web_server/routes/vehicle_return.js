var express = require('express');
var router = express.Router();

var vehicle_return_controller = require('../controllers/vehicle_return_controller');

router.post('/', vehicle_return_controller.create_return);

module.exports = router;