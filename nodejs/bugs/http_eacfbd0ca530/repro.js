const http = require('http');
const net = require('net');
const target = 'target.example.com:443';
const server = net.createServer((socket) => {
  socket.once('data', (data) => {
    const lines = data.toString().split('\r\n');
    console.log(lines[0]);
    console.log(lines.filter((l) => /^host:/i.test(l)).join('|'));
    socket.end('HTTP/1.1 200 Connection established\r\n\r\n');
  });
});
server.listen(0, '127.0.0.1', () => {
  const req = http.request({
    host: '127.0.0.1', port: server.address().port,
    method: 'CONNECT', path: target,
  });
  req.on('connect', (res, socket) => {
    socket.destroy();
    server.close();
  });
  req.end();
});
