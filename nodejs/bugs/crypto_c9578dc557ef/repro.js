// Run with --allow-natives-syntax via re-spawn so a crash is reported deterministically.
const { spawnSync } = require('child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--allow-natives-syntax', __filename, 'child'], { encoding: 'utf8' });
  console.log('status', r.status === 0 ? 'ok' : 'abnormal');
  console.log(r.stdout);
  process.exit(0);
}
const crypto = require('crypto');
const foo = Buffer.from('foo');
function t(a, b) { return crypto.timingSafeEqual(a, b); }
eval('%PrepareFunctionForOptimization(t)');
t(foo, foo);
eval('%OptimizeFunctionOnNextCall(t)');
t(foo, foo);
for (const args of [[foo, ''], ['', ''], [{}, foo]]) {
  try { t(...args); console.log('no throw'); } catch (e) { console.log(e.code); }
}
