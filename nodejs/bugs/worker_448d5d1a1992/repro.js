'use strict';
const { getHeapSnapshot } = require('v8');
const { isMainThread, Worker } = require('worker_threads');
if (isMainThread) {
  const worker = new Worker('1', { eval: true })
  worker.once('exit', (code) => {
    console.log('exit', code);
    let n = 0;
    const s = getHeapSnapshot();
    s.on('data', (c) => { n += c.length; });
    s.on('end', () => console.log('snapshot ok', n > 0));
  });
}
