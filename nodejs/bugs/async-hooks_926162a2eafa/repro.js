'use strict';
if (process.argv[2] !== 'child') {
  const r = require('child_process').spawnSync(process.execPath,
    ['--expose-internals', __filename, 'child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout + r.stderr);
  console.log('child exit', r.status);
  return;
}
const { createHook } = require('async_hooks');
const { enabledHooksExist } = require('internal/async_hooks');
const out = [enabledHooksExist()];
const ah = createHook({ init() {} });
out.push(enabledHooksExist());
ah.enable();
out.push(enabledHooksExist());
ah.disable();
out.push(enabledHooksExist());
console.log(out.join(','));
