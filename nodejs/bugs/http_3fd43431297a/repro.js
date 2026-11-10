const http = require('http');
const s = http.createServer((req, res) => {
  res.setHeader('Content-Length', '2');
  res.setHeader('content-disposition', 'attachment; filename="é.txt"');
  res.end('ok');
});
s.listen(0, () => {
  const sock = require('net').connect(s.address().port, () => sock.write('GET / HTTP/1.1\r\nHost: x\r\nConnection: close\r\n\r\n'));
  const chunks = [];
  sock.on('data', d => chunks.push(d));
  sock.on('end', () => {
    const b = Buffer.concat(chunks);
    const i = b.indexOf('content-disposition');
    console.log(b.subarray(i, b.indexOf('\r\n', i)).toString('hex'));
    s.close();
  });
});
