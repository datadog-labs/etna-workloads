// Run with --expose-gc via re-spawn
const { spawnSync } = require('child_process');
if (!process.argv.includes('child')) {
  const r = spawnSync(process.execPath, ['--expose-gc', '--experimental-ffi', __filename, 'child'], { encoding: 'utf8' });
  console.log('status', r.status, 'signal', r.signal);
  process.stdout.write(r.stdout);
  process.exit(0);
}
const ffi = require('node:ffi');
(async () => {
  const { lib } = ffi.dlopen(null, {});
  let cb = () => 1;
  const ref = new WeakRef(cb);
  const p = lib.registerCallback({ arguments: ['i32'], return: 'i32' }, cb);
  lib.unrefCallback(p);
  cb = null;
  for (let i = 0; i < 200 && ref.deref() !== undefined; i++) {
    await new Promise((r) => setImmediate(r));
    global.gc();
  }
  console.log('collected', ref.deref() === undefined);
  for (const m of ['unrefCallback', 'refCallback']) {
    try { lib[m](p); console.log(m, 'no throw'); } catch (e) { console.log(m, e.code); }
  }
})();
