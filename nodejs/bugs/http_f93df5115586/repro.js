const http = require('http');
const server = http.createServer((req, res) => {
  const r = res.writeHead(200, { 'X-A': '1' });
  console.log('returns response:', r === res);
  r.end('ok');
});
server.listen(0, () => {
  http.get({ port: server.address().port }, (res) => {
    res.resume();
    res.on('end', () => server.close());
  });
});
