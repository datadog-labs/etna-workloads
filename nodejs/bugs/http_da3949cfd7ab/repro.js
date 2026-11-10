'use strict';
const http = require('http');
const server = http.createServer((req, res) => {
  req.socket.parser.free = () => { console.log('free called'); };
  req.socket.on('close', () => { server.close(() => console.log('server closed')); });
  res.end('ok');
}).listen(0, () => {
  http.get({ agent: false, port: server.address().port, path: '/' },
           (res) => res.resume());
});
