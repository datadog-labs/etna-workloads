'use strict';
const http = require('http');
process.on('uncaughtException', (e) => {
  console.log('uncaught:', e.constructor.name);
  process.exit(1);
});
const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.write('okay', () => { delete res.socket.parser; });
  res.end();
});
server.listen(0, '127.0.0.1', () => {
  const req = http.request({ agent: false, port: server.address().port, host: '127.0.0.1' });
  req.on('response', (r) => r.resume());
  req.on('close', () => setTimeout(() => { console.log('done'); server.close(); }, 200));
  req.end();
});
