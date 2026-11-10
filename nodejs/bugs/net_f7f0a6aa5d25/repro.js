const net = require('net');
const server = net.createServer((s) => { s.end(); });
server.listen(0, () => {
  const c = net.connect(server.address().port);
  c.on('error', (e) => console.log('error:', e.code, e.message));
  c.on('end', () => {
    const r = c.write('x', (err) => console.log('cb:', err && err.code));
    console.log('write returned', r);
  });
  c.on('close', () => { console.log('close'); server.close(); });
  c.resume();
});
