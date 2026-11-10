'use strict';
const net = require('net');
const cluster = require('cluster');
if (cluster.isPrimary) {
  const worker = cluster.fork();
  const server = net.createServer();
  const timer = setTimeout(() => {
    console.log('worker did not receive server (hang)');
    worker.kill();
    server.close();
    process.exitCode = 1;
  }, 8000);
  worker.on('online', () => {
    server.listen(() => worker.send(null, server));
  });
  worker.on('message', (m) => console.log('worker:', m));
  worker.on('exit', (code) => {
    clearTimeout(timer);
    console.log('worker exit', code);
    server.close();
  });
} else {
  process.on('message', (_, server) => {
    process.send(server instanceof net.Server ? 'got server' : 'bad');
    process.exit(0);
  });
}
