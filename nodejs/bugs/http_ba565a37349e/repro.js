const net = require('net');
const http = require('http');
const server = net.createServer((s) => {
  s.on('data', () => {});
  s.end('BAD RESPONSE\r\n\r\n');
});
server.listen(0, () => {
  http.get({ port: server.address().port }, () => {}).on('error', (e) => {
    console.log(e.code);
    console.log(e.message);
    server.close();
  });
});
