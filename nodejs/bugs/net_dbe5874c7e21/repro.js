const net = require('net');
const server = net.createServer({ keepAlive: true, keepAliveInitialDelay: 1000, noDelay: true }, (s) => {
  console.log('server socket kSetNoDelay-based noDelay:', s._handle ? 'has handle' : 'none');
  s.destroy(); server.close();
});
server.listen(0, () => {
  const orig = server._handle.onconnection;
  server._handle.onconnection = (err, ch) => {
    for (const m of ['setKeepAlive', 'setNoDelay']) {
      const f = ch[m];
      ch[m] = (...a) => { console.log('client handle', m, JSON.stringify(a)); return f.apply(ch, a); };
    }
    orig.call(server._handle, err, ch);
  };
  net.connect(server.address().port);
});
