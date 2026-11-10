const { Agent, createServer, get } = require('http');
const server = createServer((req, res) => res.end());
server.listen(0, () => {
  const agent = new Agent({ keepAlive: true, maxSockets: 1 });
  let socket;
  const req = get({ agent, port: server.address().port }, (res) => {
    res.on('end', () => {
      req.setTimeout(0);
      console.log('socket timeout listeners:', socket.listenerCount('timeout'));
      agent.destroy();
      server.close();
    });
    res.resume();
  });
  req.on('socket', (s) => { socket = s; });
});
