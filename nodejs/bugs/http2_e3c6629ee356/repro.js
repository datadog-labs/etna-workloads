'use strict';
const http2 = require('http2');
const server = http2.createServer();
let serverSocket;
server.on('connection', (s) => { serverSocket = s; s.on('error', () => {}); });
server.on('sessionError', () => {});
server.on('stream', (stream) => {
  stream.respond({ ':status': 200 });
  stream.write('partial', () => setImmediate(() => serverSocket.destroy()));
});
server.listen(0, () => {
  const session = http2.connect(`http://localhost:${server.address().port}`);
  session.on('error', () => {});
  session.on('close', () => { console.log('session close'); server.close(); });
  const req = session.request({ ':path': '/close' });
  req.on('error', () => {});
  req.on('close', () => {
    console.log('stream close');
    try {
      const r2 = session.request({ ':path': '/again' });
      r2.on('error', (e) => console.log('req2 error event'));
    } catch (e) {
      console.log('sync throw');
    }
  });
  req.resume();
});
