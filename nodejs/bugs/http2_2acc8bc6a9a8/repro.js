'use strict';
const h2 = require('http2');
const log = [];
const server = h2.createServer();
let session;
server.on('session', (s) => {
  session = s;
  s.on('close', () => { log.push('server session close'); server.close(); });
});
server.once('request', (req, res) => {
  res.on('finish', () => session.close());
  res.end();
});
const t = setTimeout(() => { log.push('timeout'); done(); }, 5000);
function done() {
  clearTimeout(t);
  console.log(log.join('\n'));
  process.exit(0);
}
server.listen(0, () => {
  const port = server.address().port;
  const client = h2.connect(`http://localhost:${port}`, () => {
    const r = client.request({ ':path': '/', ':method': 'GET' });
    r.on('response', (h) => log.push('response ' + h[':status']));
    r.on('end', () => { log.push('stream end'); client.close(); });
    r.on('error', (e) => log.push('stream error ' + e.code));
    r.end(); r.resume();
  });
  client.on('goaway', () => { if (!log.includes('goaway')) log.push('goaway'); });
  client.on('error', (e) => log.push('client error ' + e.code));
  client.on('close', () => { log.push('client close'); setTimeout(done, 200); });
});
