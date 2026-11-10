'use strict';
const http = require('http');
const server = http.createServer((req, res) => res.flushHeaders());
server.listen(0, () => {
  const req = http.get({ port: server.address().port }, () => {
    const { socket } = req;
    socket.emit('agentRemove');
    console.log('httpMessage kept:', socket._httpMessage === req);
    socket.destroy();
    server.close();
  });
});
