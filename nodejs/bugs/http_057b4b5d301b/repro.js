const http = require('http');
const net = require('net');
const server = http.createServer((req, res) => res.end('ok'));
server.keepAliveTimeout = 500;
server.listen(0, () => {
  const c = net.connect(server.address().port);
  let closed = false;
  c.on('close', () => { closed = true; });
  c.on('error', () => {});
  c.once('data', () => {
    setTimeout(() => c.write('\r\n'), 100);
  });
  c.write('GET / HTTP/1.1\r\nHost: x\r\n\r\n');
  setTimeout(() => {
    console.log(closed ? 'connection closed by keep-alive timeout' : 'connection still open');
    c.destroy();
    server.close();
    process.exit(0);
  }, 3000);
});
