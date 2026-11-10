const net = require('net');
const server = net.createServer((s) => s.end()).listen(0, '127.0.0.1', () => {
  const c = net.connect(server.address().port, '127.0.0.1');
  console.log('before connect:', c.remoteAddress);
  c.on('connect', () => {
    console.log('after connect:', c.remoteAddress, c.remoteFamily);
    c.destroy();
    server.close();
  });
});
