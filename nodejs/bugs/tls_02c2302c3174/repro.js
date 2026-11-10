'use strict';
const net = require('net');
const tls = require('tls');

const server = net.createServer((c) => c.on('error', () => {}));
server.listen(0, '127.0.0.1', () => {
  const socket = tls.connect({
    host: '127.0.0.1',
    port: server.address().port,
    rejectUnauthorized: false,
  });
  socket.on('error', () => {});
  socket.on('connect', () => {
    const sc = socket._handle._secureContext;
    console.log('singleUse flag:', sc.singleUse);
    socket.on('close', () => setImmediate(() => {
      console.log('context released after close:', sc.context === null);
      server.close();
    }));
    socket.destroy();
  });
});
