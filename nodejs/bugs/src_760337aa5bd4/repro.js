'use strict';
const { isMainThread, parentPort, workerData, Worker } = require('node:worker_threads');
const { once } = require('node:events');
const R = 'res';
if (!isMainThread) {
  parentPort.on('message', () => {});
  navigator.locks.request(R, () => {});
  parentPort.postMessage('ready');
} else {
  (async () => {
    let worker, pending;
    await navigator.locks.request(R, async () => {
      worker = new Worker(__filename);
      await once(worker, 'message');
      pending = navigator.locks.request(R, () => {});
      await new Promise((r) => setTimeout(r, 300));
      const c0 = await worker.cpuUsage();
      await new Promise((r) => setTimeout(r, 1000));
      const c1 = await worker.cpuUsage(c0);
      const busy = (c1.user + c1.system) / 1e6;
      console.log('worker busy-spinning:', busy > 0.05);
      if (process.env.DBG) console.log(busy);
    });
    await pending;
    await worker.terminate();
  })();
}
