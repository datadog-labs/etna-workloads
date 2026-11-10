'use strict';
const http2 = require('http2');
const { AsyncLocalStorage } = require('async_hooks');
const storage = new AsyncLocalStorage();
const server = http2.createServer((req, res) => { res.end('data'); });
server.listen(0, () => {
  const client = storage.run({ id: 0 }, () =>
    http2.connect(`http://localhost:${server.address().port}`));
  let ended = 0;
  const out = {};
  function doReq(id) {
    const req = client.request({ ':path': '/' });
    req.on('response', () => { out[`response${id}`] = storage.getStore()?.id; });
    req.on('data', () => { out[`data${id}`] = storage.getStore()?.id; });
    req.on('end', () => {
      out[`end${id}`] = storage.getStore()?.id;
      if (++ended === 2) {
        server.close();
        client.close();
        for (const k of Object.keys(out).sort()) console.log(k, out[k]);
      }
    });
    req.end();
  }
  storage.run({ id: 1 }, () => doReq(1));
  storage.run({ id: 2 }, () => doReq(2));
});
