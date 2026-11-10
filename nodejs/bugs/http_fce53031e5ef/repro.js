const http = require('http');
const s = http.createServer((req, res) => {
  console.log(req.headers.authorization === undefined ? 'none' :
    Buffer.from(req.headers.authorization.split(' ')[1], 'base64').toString());
  res.end('ok');
});
s.listen(0, () => {
  const u = new URL(`http://us%40er:p%3Ass%20w%2Fd@127.0.0.1:${s.address().port}/`);
  http.get(u, (res) => { res.resume(); res.on('end', () => s.close()); });
});
