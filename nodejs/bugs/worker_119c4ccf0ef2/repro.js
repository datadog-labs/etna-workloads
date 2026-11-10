'use strict';
const { Worker } = require('worker_threads');
const w = new Worker(`
const { parentPort } = require('worker_threads');
parentPort.postMessage(new SharedArrayBuffer(4));
`, { eval: true });
let sab;
w.once('message', (m) => sab = m);
w.once('exit', () => {
  const u = new Uint8Array(sab);
  u[0] = 42;
  console.log(Array.from(u).join(','));
});
