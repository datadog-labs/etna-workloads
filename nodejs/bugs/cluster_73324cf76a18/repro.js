'use strict';
const cluster = require('cluster');
if (cluster.isPrimary) {
  const w = cluster.fork();
  let exitedMsgs = 0;
  w.on('message', (m) => { if (m === 'ready') w.send('go'); });
  w.on('error', () => {});
  w.on('exit', (code, sig) => {
    console.log('exit', code, sig);
  });
  w.process.on('internalMessage', (m) => {
    if (m && m.act === 'exitedAfterDisconnect') exitedMsgs++;
  });
  w.on('disconnect', () => setTimeout(() => console.log('exitedAfterDisconnect msgs:', exitedMsgs), 200));
} else {
  process.on('uncaughtException', (e) => { console.log('worker error', e.code); process.exit(3); });
  process.on('message', () => {
    const w = cluster.worker;
    w.destroy(); w.destroy(); w.disconnect(); w.disconnect();
  });
  process.send('ready');
}
