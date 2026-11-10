const tls = require('tls');
const server = tls.createServer({});
server.addContext('example.com', {});
server.addContext('example.com', {});
const ctxs = server._contexts;
server.on('tlsClientError', (err, sock) => {
  sock._SNICallback.call(sock, 'example.com', (e, ctx) => {
    console.log('picked most recent context:', ctx === ctxs[1][1]);
    console.log('picked first context:', ctx === ctxs[0][1]);
    server.close();
    sock.destroy();
  });
});
server.listen(0, () => {
  const c = tls.connect({ port: server.address().port, servername: 'example.com', rejectUnauthorized: false });
  c.on('error', () => {});
});
