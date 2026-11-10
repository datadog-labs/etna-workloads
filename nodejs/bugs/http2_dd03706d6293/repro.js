'use strict';
const http2 = require('http2');
const net = require('net');
const server = http2.createServer();
server.on('stream', (s) => { s.respond(); s.end('ok'); });
server.listen(0, () => {
  const client = http2.connect(`http://localhost:${server.address().port}`);
  const socket = client.socket;
  const req = client.request();
  req.resume();
  req.on('close', () => {
    client.close();
    server.close();
    setImmediate(() => {
      const t = (f) => { try { f(); console.log('no error'); } catch (e) { console.log(e.code || e.name); } };
      t(() => socket.example);
      t(() => { socket.example = 1; });
      t(() => socket instanceof net.Socket);
    });
  });
});
