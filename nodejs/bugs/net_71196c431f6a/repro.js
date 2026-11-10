const net = require('net');
const server = net.createServer((c) => c.end()).listen(0, '127.0.0.1', () => {
  const s = net.connect({
    port: server.address().port, host: 'x.invalid', autoSelectFamily: false,
    lookup: (h, o, cb) => cb(null, { toString() { return '127.0.0.1'; } }, 4),
  });
  s.on('error', (e) => { console.log('error', e.code); server.close(); });
  s.on('connect', () => { console.log('connect'); s.destroy(); server.close(); });
});
