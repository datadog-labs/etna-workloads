const http2 = require('http2');
const net = require('net');
const server = net.createServer((s) => { s.on('error', () => {}); s.destroy(); });
server.listen(0, '127.0.0.1', () => {
  const port = server.address().port;
  // Pass a non-default option (localAddress) that should reach net.connect.
  // Use an unassignable local address: with the fix, connect fails with EADDRNOTAVAIL.
  const c = http2.connect(`http://127.0.0.1:${port}`, { localAddress: '203.0.113.7' });
  c.on('error', (e) => { console.log('error', e.code); server.close(); });
  c.on('connect', () => { console.log('connected'); c.destroy(); server.close(); });
  c.on('close', () => { server.close(); });
});
