var path = require('path');
var express = require('express');

var app = express();

const staticFiles = express.static(path.join(__dirname, 'dist'))
app.use(staticFiles)

app.get('*', function(req, res) {
  res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});

var port = process.env.PORT || 3000;

app.listen(port, function(err) {
  if (err) {
    console.log(err);
    return;
  }

  console.log('Listening at http://localhost:3000');
});
