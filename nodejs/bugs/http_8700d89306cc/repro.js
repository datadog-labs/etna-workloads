const http = require('http');
const server = http.createServer((req, res) => res.end('ok'));
server.listen(0, () => {
  const agent = new http.Agent({ keepAlive: true, maxSockets: 1 });
  const port = server.address().port;
  const get = (cb) => {
    const req = http.get({ port, agent }, (res) => {
      res.resume();
      res.on('end', () => cb(null, req.socket));
    });
    req.on('error', (e) => cb(e));
  };
  get((err, sock) => {
    setTimeout(() => {
      const n = Object.values(agent.freeSockets).flat().length;
      console.log('free sockets:', n);
      sock.destroy();
      get((err2) => {
        console.log('second request:', err2 ? 'error' : 'ok');
        agent.destroy();
        server.close();
      });
    }, 50);
  });
});
