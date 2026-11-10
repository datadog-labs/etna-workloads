const http = require('http');
const server = http.createServer((req, res) => {
  const c = [];
  req.on('data', (d) => c.push(d));
  req.on('end', () => {
    console.log('body', Buffer.concat(c).toString('hex'));
    res.end();
    server.close();
  });
});
server.listen(0, () => {
  const req = http.request({ port: server.address().port, method: 'POST' }, (res) => res.resume());
  req.write('ff1', 'hex');
  req.end();
});
