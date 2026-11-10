'use strict';
const http2 = require('http2');
const server = http2.createServer();
server.on('stream', (stream) => {
  server.close();
  stream.session.close();
  stream.on('wantTrailers', () => stream.sendTrailers({ xyz: 'abc' }));
  stream.respond({ ':status': 200 }, { waitForTrailers: true });
  stream.write('some data');
  stream.end();
});
const timer = setTimeout(() => { console.log('process still alive after 5s (hang)'); process.exit(2); }, 5000); timer.unref();
server.listen(0, () => {
  const client = http2.connect(`http://localhost:${server.address().port}`);
  client.on('error', (e) => console.log('client error', e.code));
  const req = client.request({ ':path': '/', ':method': 'POST' });
  req.end();
  let data = '';
  req.on('data', (c) => data += c);
  req.on('error', (e) => console.log('req error', e.code));
  req.on('trailers', (h) => console.log('trailers', h.xyz));
  req.on('end', () => console.log('end', data));
  req.on('close', () => { console.log('close', req.rstCode); });
});
