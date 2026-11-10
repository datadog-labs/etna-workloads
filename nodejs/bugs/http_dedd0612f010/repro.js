const http = require('http');
const srv = http.createServer((req, res) => {
  const r = res.setHeader('A', '1');
  console.log('returns response:', r === res);
  res.end();
});
srv.listen(0, () => {
  http.get({ port: srv.address().port }, (r) => { r.resume(); r.on('end', () => srv.close()); });
});
