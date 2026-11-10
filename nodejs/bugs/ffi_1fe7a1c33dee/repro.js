const { spawnSync } = require('node:child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--experimental-ffi', '--no-warnings', __filename, 'child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout + r.stderr);
  process.exit(r.status);
}
const ffi = require('node:ffi');
const buf = new ArrayBuffer(16);
const ptr = ffi.getRawPointer(buf);
for (const [name, fn, get] of [['setFloat64', ffi.setFloat64, ffi.getFloat64], ['setFloat32', ffi.setFloat32, ffi.getFloat32]]) {
  for (const v of ['1,5', true, {}, { valueOf() { throw new Error('boom'); } }]) {
    try { fn(ptr, 0, v); console.log(name, 'accepted, read', get(ptr, 0)); }
    catch (e) { console.log(name, 'threw', e.code, e.message); }
  }
}
