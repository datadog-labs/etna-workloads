'use strict';
const http2 = require('http2');
const { PerformanceObserver } = require('perf_hooks');
const server = http2.createServer();
server.on('stream', (stream) => {
  stream.respond({ ':status': 200 });
  stream.end('OK');
});
server.listen(0, () => {
  const obs = new PerformanceObserver((list, o) => {
    for (const e of list.getEntries()) {
      if (e.name !== 'Http2Session' || e.detail.type !== 'client') continue;
      console.log('client frames received:', e.detail.framesReceived);
      o.disconnect();
      server.close();
    }
  });
  obs.observe({ type: 'http2' });
  const client = http2.connect(`http://localhost:${server.address().port}`, () => {
    const req = client.request({ ':path': '/' });
    req.resume();
    req.end();
    req.on('end', () => client.close());
  });
});
