const http2 = require('http2');
const server = http2.createServer((req, res) => {
  res.sendDate = false;
  res.end('x');
});
server.listen(0, () => {
  const c = http2.connect(`http://localhost:${server.address().port}`);
  const r = c.request({ ':path': '/' });
  r.on('response', (h) => console.log('date header present:', 'date' in h));
  r.resume();
  r.on('close', () => { c.close(); server.close(); });
});
