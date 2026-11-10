'use strict';
const http2 = require('http2');
const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
const f = path.join(dir, 'a.txt');
fs.writeFileSync(f, 'hello');
const server = http2.createServer();
server.on('stream', (stream) => {
  const orig = fs.close;
  let closed = false;
  fs.close = function(fd, cb) { closed = true; return orig.apply(this, arguments); };
  stream.on('error', (e) => console.log('error', e.code));
  stream.on('close', () => {
    fs.close = orig;
    console.log('fd closed:', closed);
  });
  stream.respondWithFile(f, { ':method': 'GET', 'content-type': 'text/plain' });
});
server.listen(0, () => {
  const client = http2.connect(`http://localhost:${server.address().port}`);
  const req = client.request();
  req.on('error', () => {});
  req.on('close', () => {
    client.close(); server.close();
    fs.rmSync(dir, { recursive: true });
  });
  req.end();
});
