'use strict';
const http = require('http');
require('v8').setFlagsFromString('--expose-gc');
const gc = require('vm').runInNewContext('gc');
const server = http.createServer((req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.end(JSON.stringify({ hello: 'world' }));
  req.socket.write('HTTP/1.1 400 Bad Request\r\n\r\n');
});
server.listen(0, () => {
  let ref = new WeakRef(http.get({ port: server.address().port }, (res) => {
    res.resume();
  }));
  let n = 0;
  const t = setInterval(() => {
    gc();
    n++;
    if (!ref.deref()) {
      console.log('request collected');
      clearInterval(t); server.close();
    } else if (n > 40) {
      console.log('request leaked');
      clearInterval(t); server.close(); process.exitCode = 1;
      server.closeAllConnections();
    }
  }, 100);
});
