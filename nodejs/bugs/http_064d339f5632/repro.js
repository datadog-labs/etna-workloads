'use strict';
const http = require('http');
const net = require('net');
const server = http.createServer(() => { });
server.maxHeadersCount = 2;
server.on('clientError', (err, socket) => {
  console.log('clientError', err.code);
  socket.end('HTTP/1.1 431 Request Header Fields Too Large\r\n\r\n');
});
server.listen(0, () => {
  const c = net.createConnection(server.address().port, '127.0.0.1', () => {
    c.end('POST / HTTP/1.1\r\nHost: localhost\r\nX-A: b\r\nContent-Length: 3\r\n\r\nabc');
  });
  let r = '';
  c.setEncoding('latin1');
  c.on('data', (d) => r += d);
  c.on('end', () => { console.log(r.split('\r\n')[0] || '(no response)'); server.close(); process.exit(0); });
  setTimeout(() => { console.log('timeout; response:', JSON.stringify(r.split('\r\n')[0])); process.exit(0); }, 3000).unref();
});
