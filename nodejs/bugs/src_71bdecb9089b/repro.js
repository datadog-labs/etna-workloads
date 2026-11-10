'use strict';
const http2 = require('http2');
const server = http2.createServer();
let client;
server.on('stream', (stream) => {
  server.close();
  stream.session.close();
  stream.on('wantTrailers', () => stream.sendTrailers({ xyz: 'abc' }));
  stream.respond({ ':status': 200 }, { waitForTrailers: true });
  stream.write('some data');
  stream.end();
});
server.listen(0, () => {
  client = http2.connect(`http://localhost:${server.address().port}`);
  client.socket.on('close', () => console.log('client socket closed'));
  const req = client.request({ ':path': '/', ':method': 'POST' });
  req.end();
  req.resume();
  req.on('trailers', (h) => console.log('trailers', h.xyz));
  req.on('close', () => console.log('req close'));
});
process.on('exit', () => console.log('exit; client destroyed:', client.destroyed));
// Unref'd timer: only fires if something keeps the loop alive (hang).
setTimeout(() => { console.log('HANG: still alive after 3s'); process.exit(1); }, 3000).unref();
setTimeout(() => {}, 4000).unref();
