'use strict';
const http2 = require('http2');
const BODY = Buffer.alloc(2048, 'a');
let remaining = 40;
const server = http2.createServer({ settings: { maxConcurrentStreams: 4 } });
server.on('session', (s) => s.on('error', () => {}));
server.on('stream', (stream) => {
  stream.on('error', () => {});
  stream.session.destroy();
});
server.listen(0, '127.0.0.1', () => {
  const origin = `http://127.0.0.1:${server.address().port}`;
  const round = () => {
    if (remaining-- <= 0) { console.log('done'); server.close(); return; }
    const session = http2.connect(origin);
    session.on('error', () => {});
    session.on('close', () => setImmediate(round));
    session.on('connect', () => {
      for (let i = 0; i < 8; i++) {
        const s = session.request({ ':path': `/${i}`, ':method': 'POST' });
        s.on('error', () => {});
        s.resume();
        s.end(BODY);
      }
    });
  };
  round();
});
