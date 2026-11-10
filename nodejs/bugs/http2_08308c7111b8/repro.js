const http2 = require('http2');
const server = http2.createServer((req, res) => {
  res.setHeader('date', 'snacks o clock');
  res.end();
});
server.listen(0, () => {
  const session = http2.connect(`http://localhost:${server.address().port}`);
  const req = session.request();
  req.on('response', (h) => console.log('date header:', h.date));
  req.on('end', () => { session.close(); server.close(); });
  req.resume();
});
