'use strict';
const { spawnSync } = require('node:child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--experimental-ffi', '--permission', '--allow-ffi', '--allow-fs-read=*', __filename, 'child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout + r.stderr);
  console.log('exit', r.status);
} else {
  const ffi = require('node:ffi');
  const lib = new ffi.DynamicLibrary(null);
  process.permission.drop('ffi');
  try { console.log('dlsym', typeof ffi.dlsym(lib, 'malloc')); } catch (e) { console.log('dlsym', e.code); }
  try { ffi.dlclose(lib); console.log('dlclose ok'); } catch (e) { console.log('dlclose', e.code); }
}
