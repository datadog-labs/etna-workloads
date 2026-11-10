// Run with fast API enabled via natives syntax in a child process.
const { spawnSync } = require('child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--expose-internals', '--no-warnings', '--allow-natives-syntax', __filename, 'child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout); process.stdout.write(r.stderr);
  process.exit(r.status);
}
const { internalBinding } = require('internal/test/binding');
const { utf8Write } = require('internal/buffer');
function t() {
  const buf = Buffer.alloc(64);
  const n = buf.write('éñüçßÆ');
  return Array.from(buf.subarray(0, n)).join(',');
}
eval('%PrepareFunctionForOptimization(utf8Write)');
console.log(t());
eval('%OptimizeFunctionOnNextCall(utf8Write)');
console.log(t());
console.log('fast calls > 0:', internalBinding('debug').getV8FastApiCallCount('buffer.writeString') > 0);
