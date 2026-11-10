const http2 = require('http2');
const server = http2.createServer((req, res) => res.end('ok'));
server.listen(0, () => {
  const client = http2.connect(`http://localhost:${server.address().port}`);
  client.on('error', () => {});
  const req = client.request({ ':path': '/' });
  req.resume();
  req.on('close', () => {
    let closed = false;
    client.on('close', () => console.log('client session closed'));
    server.close(() => { closed = true; console.log('server closed'); });
    setTimeout(() => {
      console.log('server.close completed:', closed);
      process.exit(closed ? 0 : 1);
    }, 2000);
  });
});
