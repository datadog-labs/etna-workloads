'use strict';
const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');

const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const waiter = path.join(dir, 'wait.js');
const main = path.join(dir, 'main.js');
fs.writeFileSync(waiter, `
const fs = require('fs');
const [, , parent, marker] = process.argv;
fs.writeFileSync(marker, '');
setInterval(() => { if (process.ppid !== Number(parent)) process.exit(); }, 50);
setTimeout(() => process.exit(), 20000);
`);
fs.writeFileSync(main, `
const fs = require('fs');
const { Worker } = require('worker_threads');
const childMarker = process.argv[2];
new Worker(\`
  require('child_process').execFileSync(process.execPath,
    [\${JSON.stringify(process.argv[3])}, String(process.pid), \${JSON.stringify(childMarker)}],
    { stdio: 'ignore' });
\`, { eval: true });
const i = setInterval(() => {
  if (!fs.existsSync(childMarker)) return;
  clearInterval(i);
  process.exit(0);
}, 10);
`);

const r = spawnSync(process.execPath, ['--process-timeout=3000ms', main,
  path.join(dir, 'marker'), waiter], { encoding: 'utf8' });
console.log('status', r.status, 'signal', r.signal);
console.log('not-finished-exiting:', /did not finish exiting after the event loop had stopped/.test(r.stderr));
console.log('blames main thread:', /main thread did not respond/.test(r.stderr));
fs.rmSync(dir, { recursive: true, force: true });
