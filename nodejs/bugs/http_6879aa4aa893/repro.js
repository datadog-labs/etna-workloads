const http = require('http');
const server = http.createServer((req, res) => {
  req.resume();
  req.on('end', () => res.end('ok'));
});
server.listen(0, () => {
  const port = server.address().port;
  const req = http.request({ port, method: 'POST', highWaterMark: 100000 }, (res) => {
    res.resume();
    res.on('end', () => { console.log('done'); server.close(); });
  });
  console.log('write 64KB returns', req.write(Buffer.alloc(64 * 1024)));
  req.end();
});
