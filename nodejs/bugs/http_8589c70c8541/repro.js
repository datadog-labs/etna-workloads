const http = require('http');
const server = http.createServer((req, res) => {
  res.end('hi');
  console.log('server res.writable after end:', res.writable);
  res.on('finish', () => {
    console.log('server res.writable on finish:', res.writable);
  });
});
server.listen(0, () => {
  const req = http.get({ port: server.address().port }, (res) => {
    res.resume();
    res.on('end', () => server.close());
  });
  console.log('client req.writable after end:', req.writable);
});
