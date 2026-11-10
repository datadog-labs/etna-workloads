// Flags needed: run with --allow-natives-syntax (re-spawned below).
if (!process.execArgv.includes('--allow-natives-syntax')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--allow-natives-syntax', '--experimental-ffi', __filename], { encoding: 'utf8' });
  process.stdout.write(r.stdout); process.stderr.write(r.stderr);
  process.exit(r.status);
}
process.removeAllListeners('warning'); process.emitWarning = () => {};
const ffi = require('node:ffi');
const lib = new ffi.DynamicLibrary('libc.so.6');
// strtod(const char*, char**) -> double: pointer-only args plus float return.
const strtod = lib.getFunction('strtod', { arguments: ['pointer', 'pointer'], return: 'f64' });
const keep = Buffer.from('1.5\0'); const buf = ffi.getRawPointer(keep);
function call(v) { return strtod(buf, v); }
eval('%PrepareFunctionForOptimization(call)');
call(0n); call(0n);
eval('%OptimizeFunctionOnNextCall(call)');
call(0n);
for (const v of [2n ** 64n, -(2n ** 64n), 2n ** 64n + 0n * 5n]) {
  try { console.log('returned', call(v)); } catch (e) { console.log(e.code); }
}
