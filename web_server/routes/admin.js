var express = require('express');
var router = express.Router();

var admin_controller = require('../controllers/admin_controller');

router.delete('/', admin_controller.reset_database);

router.delete('/r', admin_controller.delete_r);

module.exports = router;