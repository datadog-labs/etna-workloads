'use strict';
const http = require('http');
const net = require('net');
process.on('warning', (w) => console.log('warning:', w.message));
let i = 0, socket;
const server = http.createServer();
server.on('clientError', () => {
  if (i === 5) socket.end(); else { socket.write('*'); i++; }
});
server.listen(0, () => {
  socket = net.createConnection({ port: server.address().port });
  socket.on('connect', () => socket.write('*'));
  socket.on('close', () => { console.log('closed, errors:', i); server.close(); });
});
