const http2 = require('http2');
const app = http2.createServer((req, res) => {
  res.end('hello');
  setImmediate(() => req.socket.destroy());
});
process.on('uncaughtException', (e) => { console.log('uncaught', e.code || e.message); process.exit(1); });
app.listen(0, () => {
  const session = http2.connect(`http://localhost:${app.address().port}`);
  session.on('error', () => {});
  const r = session.request({ ':path': '/' });
  r.on('error', () => {});
  r.resume();
  r.on('end', () => { console.log('end'); session.close(); app.close(); });
  r.end();
});
