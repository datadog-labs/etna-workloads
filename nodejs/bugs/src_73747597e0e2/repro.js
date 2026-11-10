'use strict';
const { spawnSync } = require('child_process');
if (process.argv[2] === 'child') {
  require('async_hooks').createHook({ init() {} }).enable();
  function recursive(d = 0) { new Promise(() => {}); return recursive(d + 1); }
  try {
    recursive();
    console.log('no error');
  } catch (err) {
    console.log('caught', err.name, err.message);
  }
} else {
  const r = spawnSync(process.execPath, [__filename, 'child'], { encoding: 'utf8', timeout: 25000 });
  console.log('status', r.status);
  console.log('stdout', r.stdout.trim());
}
