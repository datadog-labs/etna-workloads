'use strict';
const { spawnSync } = require('child_process');
if (process.argv[2] === 'child') {
  try { require('fs').mkdirSync('/proc/repro-x', { recursive: true }); console.log('no error'); }
  catch (e) { console.log(e.code, e.syscall); }
  return;
}
const r = spawnSync(process.execPath, [__filename, 'child'], { timeout: 3000, encoding: 'utf8' });
if (r.error && r.error.code === 'ETIMEDOUT') { console.log('mkdirSync hung (infinite retry)'); process.exit(1); }
console.log(r.stdout.trim());
