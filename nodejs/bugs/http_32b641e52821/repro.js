'use strict';
const http = require('http');
const server = http.createServer().listen(0, () => {
  const c = require('net').connect(server.address().port, () => c.end());
  c.on('end', () => server.close());
});
server.on('connection', (socket) => {
  try {
    socket.setEncoding('');
    console.log('no error');
  } catch (e) {
    console.log('threw', e.code, e.message);
  }
  socket.end();
});
