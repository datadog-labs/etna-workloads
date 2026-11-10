'use strict';
const http = require('http');
const server = http.createServer(() => {});
server.listen(0, async () => {
  const agent = new http.Agent({ keepAlive: true });
  const port = server.address().port;
  let socket;
  for (let i = 0; i < 5; i++) {
    await new Promise((resolve) => {
      const req = http.get({ host: '127.0.0.1', port, agent });
      req.on('error', resolve);
      req.on('close', resolve);
      
      req.destroy();
    });
    await new Promise((r) => setImmediate(r));
  }
  console.log('free socket error listeners:', Object.values(agent.freeSockets).flat().map((s) => s.listenerCount('error')));
  server.close();
  agent.destroy();
});
