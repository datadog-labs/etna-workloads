'use strict';
const { spawnSync } = require('child_process');
if (process.argv[2] === 'child') {
  const rs1 = new ReadableStream();
  const ws1 = new WritableStream();
  structuredClone([rs1, ws1], { transfer: [rs1, ws1] });
  return;
}
const r = spawnSync(process.execPath, [__filename, 'child'], { timeout: 3000 });
console.log(r.error ? 'child hung (kept process alive)' : 'child exited, status ' + r.status);
