'use strict';
const h2 = require('http2');
process.on('uncaughtException', (e) => { console.log('uncaught:', e.code || e.message); });
const server = h2.createServer((req, res) => {
  req.stream.close();
  try { res.writeHead(200, { 'content-type': 'text/plain' }); console.log('writeHead ok'); }
  catch (e) { console.log('writeHead threw:', e.code); }
});
server.listen(0, () => {
  const client = h2.connect(`http://localhost:${server.address().port}`);
  const req = client.request({ ':path': '/' });
  req.on('response', () => console.log('client got response'));
  req.on('error', () => {});
  req.on('close', () => { client.close(); server.close(); });
  req.end();
});
