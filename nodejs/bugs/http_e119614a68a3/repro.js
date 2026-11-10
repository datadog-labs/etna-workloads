const http = require('http');
const server = http.createServer((req, res) => {
  req.resume();
  setTimeout(() => {
    res.writeHead(204, { Connection: 'keep-alive', 'Keep-Alive': 'timeout=1' });
    res.end();
  }, 600);
});
const guard = setTimeout(() => { console.log("timeout: server never closed"); process.exit(1); }, 5000);
server.on("close", () => clearTimeout(guard));
server.listen(0, () => {
  const req = http.get({ port: server.address().port }, (res) => {
    console.log('response status', res.statusCode);
    res.resume();
    server.close();
  });
  req.on('error', (e) => console.log('client error', e.code));
  req.on('finish', () => setTimeout(() => server.closeIdleConnections(), 200));
});
