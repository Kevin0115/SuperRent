var express = require('express');
var router = express.Router();

var admin_controller = require('../controllers/admin_controller');

router.delete('/', admin_controller.reset_database);

module.exports = router;