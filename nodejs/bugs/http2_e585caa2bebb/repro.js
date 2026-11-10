'use strict';
const http2 = require('http2');
const server = http2.createServer((req, res) => res.end('Hi!\n'));
server.listen(0, () => {
  const client = http2.connect(`http://localhost:${server.address().port}`);
  const req = client.request({ ':path': '/' });
  req.on('close', () => {
    req.removeAllListeners();
    req.on('priority', () => {});
    console.log('ok');
    server.close();
  });
  req.on('priority', () => {});
  req.on('error', () => {});
  client.destroy();
});
