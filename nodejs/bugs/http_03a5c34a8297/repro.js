'use strict';
const http = require('http');
const net = require('net');
const server = http.createServer((req, res) => {
  req.on('end', () => { res.writeHead(200); res.end('bye'); });
  req.resume();
});
server.listen(0, () => {
  const sock = net.connect(server.address().port);
  let data = '';
  sock.on('data', (c) => data += c);
  sock.on('end', () => {
    console.log(JSON.stringify(data.split('\r\n')[0]));
    server.close();
  });
  sock.end('GET / HTTP/1.1\r\nHost: x\r\nTransfer-Encoding: chunked\r\n\r\n' +
    '2;' + 'a'.repeat(17000) + '\r\nAA\r\n0\r\n\r\n');
});
