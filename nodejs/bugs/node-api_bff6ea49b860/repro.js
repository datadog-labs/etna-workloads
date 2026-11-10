'use strict';
const path = require('path');
const { spawnSync } = require('child_process');
const bin = path.resolve(path.dirname(process.execPath), '../../test/node-api/test_threadsafe_function_shutdown/build/Release/binding.node');
if (process.argv[2] === 'child') {
  const m = { exports: {} };
  process.dlopen(m, bin);
  m.exports();
  setTimeout(() => {}, 100);
} else {
  let ok = 0;
  for (let i = 0; i < 5; i++) {
    const r = spawnSync(process.execPath, [__filename, 'child'], { stdio: 'ignore' });
    if (r.status === 0) ok++;
  }
  console.log(`clean exits: ${ok}/5`);
}
