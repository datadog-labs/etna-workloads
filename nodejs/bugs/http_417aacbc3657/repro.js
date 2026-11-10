'use strict';
const http = require('http');
const net = require('net');
const server = http.createServer(() => {});
let closed = false;
const t = setTimeout(() => {
  console.log('client socket closed:', closed);
  process.exit(0);
}, 1500);
server.listen(0, '127.0.0.1', () => {
  server.once('connection', () => {
    server.closeIdleConnections();
  });
  const s = net.createConnection(server.address().port, '127.0.0.1');
  s.on('close', () => {
    closed = true;
    console.log('client socket closed:', closed);
    clearTimeout(t);
    process.exit(0);
  });
  s.on('error', () => {});
});
