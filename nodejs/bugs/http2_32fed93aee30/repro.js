'use strict';
const http2 = require('http2');
process.on('uncaughtException', (e) => {
  console.log('uncaught:', e.code || e.name);
  process.exit(1);
});
const server = http2.createServer((req, res) => {
  req.stream.destroy();
  try {
    res.writeHead(200);
    res.write('hello ');
    res.end('world');
    console.log('server ok');
  } catch (e) {
    console.log('threw:', e.code || e.name);
  }
});
server.listen(0, () => {
  const client = http2.connect(`http://localhost:${server.address().port}`);
  const req = client.request();
  req.on('response', () => console.log('unexpected response'));
  req.on('close', () => { client.close(); server.close(); console.log('done'); });
  req.resume();
});
