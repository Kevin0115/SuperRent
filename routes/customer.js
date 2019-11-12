var express = require('express');
var router = express.Router();

var customer_controller = require('../controllers/customer_controller');

router.get('/', customer_controller.get_all_customers);

router.get('/:dlicense', customer_controller.get_customer_by_dlicense);

router.post('/', customer_controller.create_customer);

router.delete('/', customer_controller.delete_all_customers);

module.exports = router;