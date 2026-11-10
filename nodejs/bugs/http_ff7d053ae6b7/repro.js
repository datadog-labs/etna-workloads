const http = require('http');
const net = require('net');
const server = http.createServer();
server.on('connection', (s) => {
  s.on('error', (e) => console.log('server socket error:', e.code));
  s.on('close', () => console.log('server socket closed'));
});
server.listen(0, () => {
  const c = net.connect({ port: server.address().port, allowHalfOpen: true });
  let data = '';
  c.on('connect', () => c.write('FOO /\r\n'));
  c.on('data', (d) => data += d);
  c.on('close', () => {
    console.log('client got:', JSON.stringify(data));
    setTimeout(() => server.close(), 100);
  });
  c.on('end', () => { c.end(); });
  setTimeout(() => { console.log('timeout'); process.exit(0); }, 3000).unref();
});
