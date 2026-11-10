'use strict';
const { spawnSync } = require('child_process');
const { isMainThread } = require('worker_threads');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath,
    ['--expose-internals', '--no-warnings', __filename, 'child'],
    { encoding: 'utf8', timeout: 20000 });
  process.stdout.write(r.stdout);
  process.stderr.write(r.stderr);
  process.exit(r.status);
}
const { internalBinding } = require('internal/test/binding');
const { Worker } = require('worker_threads');
const pb = internalBinding('process_methods');
const orig = pb.chdir;
const before = process.cwd();
const i32 = new Int32Array(new SharedArrayBuffer(12));
pb.chdir = function(path) {
  Atomics.store(i32, 0, 1); Atomics.notify(i32, 0);
  Atomics.wait(i32, 1, 0);
  return orig(path);
};
const worker = new Worker(`
  const { parentPort, workerData: { i32 } } = require('worker_threads');
  Atomics.wait(i32, 0, 0);
  const during = process.cwd();
  Atomics.store(i32, 1, 1); Atomics.notify(i32, 1);
  Atomics.wait(i32, 2, 0);
  parentPort.postMessage({ during, after: process.cwd() });
`, { eval: true, workerData: { i32 } });
worker.on('message', ({ during, after }) => {
  console.log('during chdir is original:', during === before);
  console.log('after chdir matches main:', after === process.cwd());
});
process.chdir('..');
Atomics.store(i32, 2, 1); Atomics.notify(i32, 2);
