// Require dependencies
var express = require('express');
var app = express();
var http = require('http');

var test = require('./routes/test');

// Declare application parameters
var HTTP_PORT = 3000;

// Routes
app.use('/test', test);

// Server
var httpServer = http.createServer(app);

httpServer.listen(HTTP_PORT, function() {
  console.log('[Express.js] Server listening on PORT: '+ HTTP_PORT);
});
