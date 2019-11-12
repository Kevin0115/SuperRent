var express = require('express');
var router = express.Router();

var test_controller = require('../controllers/test_controller');

router.get('/', test_controller.test_insert);

router.get('/a', test_controller.test_select);


module.exports = router;