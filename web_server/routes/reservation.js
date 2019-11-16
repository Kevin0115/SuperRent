var express = require('express');
var router = express.Router();

var reservation_controller = require('../controllers/reservation_controller');

router.post('/', reservation_controller.create_reservation);

module.exports = router;