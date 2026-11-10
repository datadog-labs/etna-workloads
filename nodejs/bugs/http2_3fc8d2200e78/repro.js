'use strict';
const h2 = require('http2');
const server = h2.createServer();
let done = false;
const timer = setTimeout(() => {
  console.log('result: timeout/failure');
  process.exit(1);
}, 5000);
server.listen(0, () => {
  const proxyClient = h2.connect(`http://localhost:${server.address().port}`);
  proxyClient.on('error', (e) => console.log('proxyClient error', e.code));
  const request = proxyClient.request({ ':method': 'CONNECT', ':authority': 'example.com:80' });
  request.on('response', (r) => {
    console.log('connect status', r[':status']);
    const proxiedClient = h2.connect('http://example.com', { createConnection: () => request });
    proxiedClient.on('error', (e) => console.log('proxiedClient error', e.code));
    const pr = proxiedClient.request();
    pr.on('response', (res) => {
      console.log('proxied status', res[':status']);
      done = true;
      proxiedClient.close(); proxyClient.close(); server.close();
      clearTimeout(timer);
      console.log('result: ok');
    });
    pr.on('error', (e) => console.log('proxied request error', e.code));
  });
});
server.once('connect', (req, res) => { res.writeHead(200); server.emit('connection', res.stream); });
server.once('request', (req, res) => { res.writeHead(204); res.end(); });
