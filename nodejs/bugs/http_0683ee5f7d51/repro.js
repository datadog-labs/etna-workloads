'use strict';
const http = require('http');
const poison = 'HTTP/1.1 200 OK\r\nX-Poisoned: true\r\nConnection: keep-alive\r\nContent-Length: 0\r\n\r\n';
let serverSocket;
const server = http.createServer((req, res) => { serverSocket ||= req.socket; res.end(req.url); });
server.listen(0, () => {
  const agent = new http.Agent({ keepAlive: true });
  const options = { host: '127.0.0.1', port: server.address().port, agent };
  const name = agent.getName(options);
  const r1 = http.request({ ...options, path: '/request1' });
  r1.end();
  r1.on('response', (res) => res.resume());
  r1.on('close', () => process.nextTick(() => {
    const free = agent.freeSockets[name][0];
    serverSocket.write(poison);
    // Block the loop so the data lands in the OS buffer without being polled.
    const end = Date.now() + 500;
    while (Date.now() < end);
    const r2 = http.request({ ...options, path: '/request2' });
    r2.end();
    console.log('free socket destroyed:', free.destroyed);
    console.log('reusedSocket:', r2.reusedSocket);
    r2.on('response', (res) => {
      let body = '';
      res.on('data', (c) => body += c);
      res.on('end', () => {
        console.log('poisoned header:', res.headers['x-poisoned']);
        console.log('body:', body);
        agent.destroy(); server.close();
      });
    });
  }));
});
