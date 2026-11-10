'use strict';
const http2 = require('http2');
const { AsyncLocalStorage } = require('async_hooks');
const storage = new AsyncLocalStorage();
const server = http2.createServer();
server.on('stream', (stream) => {
  stream.respond({ ':status': 200 }, { waitForTrailers: true });
  stream.on('wantTrailers', () => stream.sendTrailers({ 'grpc-status': '0' }));
  stream.write('data');
  stream.end();
});
server.listen(0, () => {
  const client = storage.run({ id: 0 }, () =>
    http2.connect(`http://localhost:${server.address().port}`));
  storage.run({ id: 1 }, () => {
    const req = client.request({ ':path': '/' });
    req.on('data', () => {});
    req.on('end', () => {
      console.log('end store id:', storage.getStore()?.id);
      server.close();
      client.close();
    });
  });
});
