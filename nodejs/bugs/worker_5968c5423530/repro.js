'use strict';
const { Worker } = require('worker_threads');
const w = new Worker(`
const p = require('worker_threads').parentPort;
while(true) p.postMessage({})`, { eval: true });
w.once('message', () => w.terminate());
w.once('exit', () => console.log('exit event received'));
setTimeout(() => {
  console.log('event loop kept alive after terminate()');
  process.exit(1);
}, 5000).unref();
process.on('exit', (c) => { if (c === 0) console.log('process exited cleanly'); });
