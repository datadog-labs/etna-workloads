const http2 = require('http2');
const server = http2.createServer((req, res) => {
  console.log('authority:', req.authority, 'host:', req.headers.host,
              ':authority:', req.headers[':authority']);
  res.end('ok');
});
server.listen(0, () => {
  const client = http2.connect(`http://localhost:${server.address().port}`);
  client.on('error', (e) => console.log('client error', e.code));
  try {
    const req = client.request({ ':path': '/', host: 'example.org' });
    req.on('error', (e) => console.log('req error', e.code));
    req.resume();
    req.on('close', () => { client.close(); server.close(); });
  } catch (e) {
    console.log('throw', e.code);
    client.close(); server.close();
  }
});
