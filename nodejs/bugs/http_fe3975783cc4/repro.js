const http = require('http');
const net = require('net');
const s = http.createServer((req, res) => {
  console.log(JSON.stringify(req.headers['x-test']));
  console.log(JSON.stringify(req.rawHeaders));
  res.end('ok');
});
s.listen(0, () => {
  const c = net.connect(s.address().port, () => {
    c.write('GET / HTTP/1.1\r\nHost: a\r\nX-Test: value \t \r\nConnection: close\r\n\r\n');
  });
  c.on('data', () => {});
  c.on('close', () => s.close());
});
