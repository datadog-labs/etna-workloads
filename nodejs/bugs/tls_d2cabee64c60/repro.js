const tls = require('tls');
const server = tls.createServer({
  SNICallback(name, cb) { cb(new Error('Invalid SNI context'), null); },
});
server.on('tlsClientError', (err, socket) => {
  console.log('error:', err.message);
  console.log('servername:', socket.servername);
});
server.listen(0, () => {
  const c = tls.connect({ port: server.address().port, servername: 'c.wrong.com', rejectUnauthorized: false });
  c.on('error', () => {});
  c.on('close', () => server.close());
});
