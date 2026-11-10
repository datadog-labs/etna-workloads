'use strict';
const net = require('net');
const http = require('http');
let got = 'none';
const server = http.createServer();
server.on('clientError', (err, socket) => {
  got = `clientError: ${err.code}`;
  socket.destroy();
});
server.listen(0, () => {
  const client = net.connect({ port: server.address().port }, () => {
    client.on('data', () => {});
    client.on('close', () => {
      console.log(got);
      server.close();
    });
    client.write('GET / HTTP/1.1\r\nContent-Length:');
    client.end();
  });
});
