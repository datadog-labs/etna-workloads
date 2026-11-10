'use strict';
const { spawnSync } = require('child_process');
if (process.argv[2] === 'child') {
  const rs1 = new ReadableStream();
  const ws1 = new WritableStream();
  const [rs2, ws2] = structuredClone([rs1, ws1], { transfer: [rs1, ws1] });
  console.log(rs2 instanceof ReadableStream, ws2 instanceof WritableStream);
} else {
  const r = spawnSync(process.execPath, [__filename, 'child'], { timeout: 5000, encoding: 'utf8' });
  console.log(r.stdout.trim());
  console.log(r.error ? 'process hung (did not exit)' : 'process exited cleanly');
}
