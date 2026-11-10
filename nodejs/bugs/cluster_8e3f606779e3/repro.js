'use strict';
const cluster = require('cluster');
const net = require('net');
if (cluster.isPrimary) {
  const w = cluster.fork();
  const t = setTimeout(() => { console.log('worker hung'); w.kill('SIGKILL'); }, 8000);
  w.on('exit', (code) => {
    clearTimeout(t);
    console.log('worker exit', code);
    process.exit(0);
  });
} else {
  process.on('uncaughtException', (e) => {
    console.log('child error:', e.code);
    process.exit(1);
  });
  const a = net.createServer();
  a.listen(0, () => {
    const b = net.createServer();
    b.listen(0, () => {
      b.close(() => {
        const c = net.createServer();
        c.listen(0, () => {
          console.log('child ok');
          process.exit(0);
        });
      });
    });
  });
}
