'use strict';
const https = require('https');
const net = require('net');
const { fork } = require('child_process');
if (process.argv[2] === 'child') {
  const request = https.get('https://localhost:' + process.argv[3]);
  request.on('error', () => {});
  request.on('socket', (socket) => { socket.unref(); });
} else {
  const server = net.createServer();
  server.listen(0, () => {
    const child = fork(__filename, ['child', server.address().port]);
    child.on('close', (code, sig) => {
      server.close();
      console.log('child exit', code, sig);
    });
  });
}
