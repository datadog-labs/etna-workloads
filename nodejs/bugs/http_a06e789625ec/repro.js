'use strict';
const { createServer } = require('http');
const { connect } = require('net');
let calls = 0;
const server = createServer((req, res) => {
  calls++;
  req.socket.emit('close');
  res.end();
});
server.listen(0, () => {
  const client = connect(server.address().port);
  client.on('close', () => {
    console.log('handler calls:', calls);
    server.close();
  });
  client.on('error', () => {});
  client.resume();
  client.end(
    'GET / HTTP/1.1\r\nHost: localhost\r\nConnection: keep-alive\r\n\r\n' +
    'GET / HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\n\r\n',
  );
});
setTimeout(() => { console.log('done'); process.exit(0); }, 1500).unref();
