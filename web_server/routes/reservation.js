var express = require('express');
var router = express.Router();

var reservation_controller = require('../controllers/reservation_controller');

router.post('/', reservation_controller.create_reservation);

router.get('/:conf_no/:dlicense', reservation_controller.get_reservation);

module.exports = router;