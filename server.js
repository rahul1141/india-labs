const { hostname } = require('os');

var connect = require('connect');
var serveStatic = require('serve-static');

connect()
    .use(serveStatic(__dirname))
    .listen(8080, () => console.log('Server running on 8080...'));

// const http = require('http');
// const message = 'Hello Cloud deployemnt\n';
// const port = 8080;
// const server = http.createServer((req, res) => {
//   res.statusCode = 200;
//   console.log('req received' + req);
//   res.setHeader('Content-Type', 'text/plain');
//   res.end(message);
// });
// server.listen(port, hostname, () => {
//   console.log(`Server running at http://${hostname()}:${port}/`);
// });
