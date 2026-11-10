'use strict';
const { spawnSync } = require('node:child_process');
const child = `
const { Worker } = require('node:worker_threads');
const src = \`
const { parentPort } = require('node:worker_threads');
const ffi = require('node:ffi');
const { lib, functions } = ffi.dlopen(null, {
  qsort: { arguments: ['pointer', 'u64', 'u64', 'pointer'], return: 'void' },
});
const cb = lib.registerCallback({ arguments: ['pointer', 'pointer'], return: 'i32' }, () => {
  parentPort.postMessage('in callback');
  for (;;);
});
const buf = Buffer.alloc(16);
functions.qsort(buf, 2, 8, cb);
\`;
const w = new Worker(src, { eval: true });
w.on('message', () => w.terminate());
w.on('exit', (c) => console.log('worker exited with code ' + c));
`;
const r = spawnSync(process.execPath, ['-e', child], { encoding: 'utf8' });
console.log('status', r.status, 'signal', r.signal);
console.log('stdout', JSON.stringify(r.stdout));
console.log('callbacks-throw-message', /Callbacks cannot throw an exception/.test(r.stderr));
