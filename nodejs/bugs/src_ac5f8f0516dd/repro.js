'use strict';
const { Worker, parentPort, isMainThread } = require('node:worker_threads');
const { spawnSync } = require('node:child_process');
if (isMainThread && !process.env.REPRO_CHILD) {
  const r = spawnSync(process.execPath, [__filename], {
    env: { ...process.env, REPRO_CHILD: '1' }, encoding: 'utf8', timeout: 8000, killSignal: 'SIGKILL',
  });
  console.log(r.stdout.includes('terminated') ? 'worker terminated OK' : 'worker.terminate() hung');
  process.exit(0);
} else if (isMainThread) {
  const w = new Worker(__filename);
  w.on('message', async () => {
    await new Promise((r) => setTimeout(r, 500));
    await w.terminate();
    console.log('terminated');
  });
} else {
  const inspector = require('node:inspector');
  inspector.open(0, undefined, false);
  parentPort.postMessage('open');
  inspector.waitForDebugger();
}
