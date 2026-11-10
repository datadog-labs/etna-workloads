// Run with: node --experimental-ffi repro.js (flag added via re-spawn if needed)
const { spawnSync } = require('child_process');
if (!process.argv.includes('--child')) {
  const r = spawnSync(process.execPath, ['--experimental-ffi', '--no-warnings', __filename, '--child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout); process.stderr.write(r.stderr);
  process.exit(r.status);
}
const ffi = require('node:ffi');
const { lib, functions } = ffi.dlopen(null, { uv_os_getpid: { parameters: [], result: 'i32' } });
console.log('accessor stable:', lib.functions.uv_os_getpid === lib.functions.uv_os_getpid);
console.log('dlopen vs accessor:', functions.uv_os_getpid === lib.functions.uv_os_getpid);
const f = lib.getFunction('uv_os_getpid', { parameters: [], result: 'i32' });
console.log('getFunction stable:', f === lib.getFunction('uv_os_getpid', { parameters: [], result: 'i32' }));
lib.close();
