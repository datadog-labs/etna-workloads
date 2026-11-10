'use strict';
if (process.argv[2] === 'child') {
  process.on('uncaughtException', (err) => {
    err.rethrow = true;
    throw err;
  });
  function throwException() { throw new Error('boom'); }
  throwException();
} else {
  const { spawnSync } = require('child_process');
  const r = spawnSync(process.execPath, [__filename, 'child']);
  const e = r.stderr.toString();
  console.log('status', r.status, 'signal', r.signal);
  console.log('has Error: boom', /Error: boom/.test(e));
  console.log('has stack', /at throwException/.test(e));
  console.log('has rethrow prop', /rethrow: true/.test(e));
}
