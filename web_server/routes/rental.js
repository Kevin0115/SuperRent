var express = require('express');
var router = express.Router();

var rental_controller = require('../controllers/rental_controller');

router.post('/:conf_no', rental_controller.create_rental_with_reservation);

router.post('/', rental_controller.create_rental_no_reservation);

module.exports = router;