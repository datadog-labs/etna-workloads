'use strict';
const { spawnSync } = require('child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath,
    ['--abort-on-uncaught-exception', __filename, 'child'],
    { encoding: 'utf8' });
  console.log('child stdout:', r.stdout.trim());
  console.log('aborted:', r.signal !== null);
  console.log('status:', r.status);
} else {
  const { Worker } = require('worker_threads');
  const w = new Worker('throw new Error("x")', { eval: true });
  w.on('error', () => console.log('worker error event'));
  w.on('exit', (c) => console.log('worker exit', c));
}
