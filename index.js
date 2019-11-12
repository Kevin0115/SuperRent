// Require dependencies
var express = require('express');
var app = express();
var http = require('http');
var bodyParser = require('body-parser');

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended : true }));
app.use(bodyParser.urlencoded({extended: true}))

// Import Routes
var test = require('./routes/test');
var customer = require('./routes/customer');

// Declare application parameters
var HTTP_PORT = 3000;

// Routes
app.use('/test', test);
app.use('/customer', customer);

// Server
var httpServer = http.createServer(app);

httpServer.listen(HTTP_PORT, function() {
  console.log('[Express.js] Server listening on PORT: '+ HTTP_PORT);
});
