'use strict';
const http2 = require('http2');
const net = require('net');
const { Duplex } = require('stream');
const BODY = 'the response body';
const held = [];
let serverStream;
let stall = false;
class S extends Duplex {
  constructor(port) {
    super();
    this.inner = net.connect(port, '127.0.0.1');
    this.inner.on('data', (c) => this.push(c));
    this.inner.on('end', () => this.push(null));
  }
  _read() {}
  _write(chunk, enc, cb) {
    this.inner.write(chunk, enc);
    if (stall) {
      held.push(cb);
      setImmediate(() => serverStream.end(BODY));
      return;
    }
    cb();
  }
  _final(cb) { this.inner.end(cb); }
  _destroy(e, cb) { this.inner.destroy(); cb(e); }
}
const server = http2.createServer();
server.on('stream', (s) => { s.respond(); serverStream = s; });
let done = false;
const timer = setTimeout(() => {
  if (done) return;
  console.log('DEADLOCK: response body never received');
  process.exit(1);
}, 3000);
server.listen(0, () => {
  const port = server.address().port;
  const client = http2.connect(`http://127.0.0.1:${port}`, {
    createConnection: () => new S(port),
  });
  const req = client.request({ ':method': 'POST' });
  let received = '';
  req.on('response', () => { stall = true; req.write(Buffer.alloc(256)); });
  req.on('data', (c) => { received += c; });
  req.on('end', () => {
    done = true;
    clearTimeout(timer);
    console.log('received:', received);
    stall = false;
    for (const cb of held) cb();
    req.end();
    client.close();
    server.close();
  });
});
