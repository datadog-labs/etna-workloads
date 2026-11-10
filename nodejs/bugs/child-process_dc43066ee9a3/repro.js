'use strict';
const cp = require('child_process');
const eightMB = 8 * 1024 * 1024;
if (process.argv[2] === 'child') {
  for (let i = 0; i < 6; i++) {
    process.send(new Uint8Array(eightMB).fill(i + 1));
    // churn memory to encourage GC of unreferenced buffers
    for (let j = 0; j < 20; j++) new Uint8Array(eightMB).fill(255);
    if (globalThis.gc) globalThis.gc();
  }
} else {
  const child = cp.spawn(process.execPath, ['--expose-gc', __filename, 'child'], {
    stdio: ['inherit', 'inherit', 'inherit', 'ipc'], serialization: 'advanced',
  });
  const got = [];
  let bad = 0;
  child.on('message', (m) => {
    let ok = m.length === eightMB;
    for (let i = 0; ok && i < m.length; i += 4097) if (m[i] !== m[0]) ok = false;
    if (!ok) bad++;
    got.push(m[0]);
  });
  child.on('exit', (code) => {
    console.log('received', got.join(','), 'corrupt', bad, 'code', code);
    process.exitCode = (bad || got.length !== 6) ? 1 : 0;
  });
}
