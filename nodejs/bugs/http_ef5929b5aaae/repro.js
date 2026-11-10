const http = require('http');
process.on('uncaughtException', (e) => { console.log('uncaught:', e.constructor.name); process.exit(1); });
const server = http.createServer((req, res) => {
  const d = req.headersDistinct;
  console.log(Object.getPrototypeOf(d) === null, JSON.stringify(d['__proto__']));
  res.end('ok');
  server.close();
});
server.listen(0, () => {
  const s = require('net').connect(server.address().port, () => {
    s.write('GET / HTTP/1.1\r\nHost: x\r\n__proto__: a\r\nConnection: close\r\n\r\n');
  });
  s.on('data', () => {});
});
