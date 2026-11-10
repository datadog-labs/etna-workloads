const http = require('http');
const server = http.createServer((req, res) => {
  res.end('hi', (err) => console.log('cb1', err));
  res.end((err) => console.log('cb2', err));
  res.on('finish', () => {
    console.log('finish, writableFinished =', res.writableFinished);
    res.end((err) => { console.log('cb3', err && err.code); server.close(); });
  });
});
server.listen(0, () => {
  http.request({ port: server.address().port }).end().on('response', (r) => r.resume());
});
