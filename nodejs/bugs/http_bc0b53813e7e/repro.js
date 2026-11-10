'use strict';
const http = require('http');
let serverSocket;
const server = http.createServer((req, res) => {
  serverSocket ||= req.socket;
  res.end(req.url);
});
server.listen(0, () => {
  const agent = new http.Agent({ keepAlive: true });
  const options = { host: '127.0.0.1', port: server.address().port, agent };
  const name = agent.getName(options);
  const r1 = http.request({ ...options, path: '/request1' });
  r1.end();
  r1.on('response', (res) => res.resume());
  r1.on('close', () => process.nextTick(() => {
    const freeSocket = agent.freeSockets[name][0];
    serverSocket.write('HTTP/1.1 200 OK\r\nX-Poisoned: true\r\nConnection: keep-alive\r\nContent-Length: 0\r\n\r\n');
    setTimeout(() => {
      console.log('free socket destroyed:', freeSocket.destroyed);
      console.log('pool entry removed:', agent.freeSockets[name] === undefined);
      const r2 = http.request({ ...options, path: '/request2' });
      r2.end();
      r2.on('response', (res) => {
        console.log('poisoned header seen:', res.headers['x-poisoned'] === 'true');
        res.resume();
        res.on('end', () => { agent.destroy(); server.close(); });
      });
    }, 50);
  }));
});
