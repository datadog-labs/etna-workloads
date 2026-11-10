const http = require('http');
const net = require('net');
const server = http.createServer();
server.on('upgrade', (req, stream, head) => {
  console.log('head:', JSON.stringify(String(head)));
  console.log('is socket:', stream instanceof net.Socket);
  let body = '';
  req.on('data', (d) => body += d);
  req.on('end', () => console.log('request body:', JSON.stringify(body)));
  let up = '';
  stream.on('data', (d) => up += d);
  stream.on('end', () => { console.log('upgrade data:', JSON.stringify(up)); stream.end(); });
});
server.listen(0, () => {
  const c = net.connect(server.address().port, () => {
    c.write('POST / HTTP/1.1\r\nHost: x\r\nConnection: Upgrade\r\nUpgrade: foo\r\nContent-Length: 5\r\n\r\nhelloWORLD');
    c.end();
  });
  c.resume();
  c.on('close', () => server.close());
});
setTimeout(() => { console.log('timeout'); process.exit(1); }, 10000).unref();
