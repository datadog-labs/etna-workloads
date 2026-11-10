// Flags via re-spawn so gc is exposed
if (!globalThis.gc) {
  const r = require('child_process').spawnSync(process.execPath, ['--expose-gc', __filename], { stdio: 'inherit' });
  process.exit(r.status);
}
const { once } = require('events');
const signal = AbortSignal.any([AbortSignal.timeout(300), AbortSignal.timeout(110000)]);
const t = setTimeout(() => { console.log('no abort within 5s'); process.exit(1); }, 5000);
setImmediate(() => gc());
once(signal, 'abort').then(() => {
  clearTimeout(t);
  console.log('aborted:', signal.reason.name);
  process.exit(0);
});
