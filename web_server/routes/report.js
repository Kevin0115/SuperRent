var express = require('express');
var router = express.Router();

var report_controller = require('../controllers/report_controller');

router.get('/rental', report_controller.get_rental);

router.get('/rental/:branch_city/:branch_location', report_controller.get_rental_for_branch);

router.get('/return', report_controller.get_return);

router.get('/return/:branch_city/:branch_location', report_controller.get_return_for_branch);

module.exports = router;