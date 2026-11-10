'use strict';
const http = require('http');
const net = require('net');
const server = http.createServer((req, res) => {
  res.write('helloworld', 'utf16le');
  res.end();
}).listen(0, () => {
  const bufs = [];
  const s = net.connect(server.address().port);
  s.write('GET / HTTP/1.0\r\n\r\n');
  s.on('data', (d) => bufs.push(d));
  s.on('end', () => {
    const r = Buffer.concat(bufs);
    const i = r.indexOf('\r\n\r\n');
    console.log(JSON.stringify(r.toString('utf16le', i + 4)));
    server.close();
  });
});
