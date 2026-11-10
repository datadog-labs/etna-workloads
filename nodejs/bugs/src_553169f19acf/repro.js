const net = require('net');
const name = '\0repro-abstract-' + 'x'.repeat(8);
const server = net.createServer((s) => { s.end('hi'); });
server.on('error', (e) => { console.log('server error', e.code); process.exit(1); });
server.listen(name, () => {
  const c = net.connect(name);
  let d = '';
  c.on('data', (b) => d += b);
  c.on('error', (e) => { console.log('client error', e.code); server.close(); });
  c.on('close', () => { console.log('data:', d); server.close(); });
});
