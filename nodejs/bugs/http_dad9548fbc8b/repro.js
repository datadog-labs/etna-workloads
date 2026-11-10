'use strict';
const http = require('http');
const server = http.createServer((req, res) => {
  req.resume();
  req.on('end', () => res.end('ok'));
});
server.listen(0, () => {
  const port = server.address().port;
  const agent = new http.Agent({ keepAlive: true });
  http.request({ port, method: 'POST', agent, highWaterMark: 1024 * 1024 }, (res) => {
    res.resume();
    res.on('end', () => setTimeout(requestB, 100));
  }).end('x');
  function requestB() {
    const reqB = http.request({ port, method: 'POST', agent, highWaterMark: 10 * 1024 }, (res) => {
      res.resume();
      res.on('end', () => { agent.destroy(); server.close(); });
    });
    reqB.on('socket', (s) => {
      console.log('socket HWM', s.writableHighWaterMark);
    });
    reqB.end('y');
  }
});
