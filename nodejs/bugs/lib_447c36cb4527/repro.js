// Run with --expose-gc (re-spawns itself if needed).
if (typeof gc !== 'function') {
  const r = require('child_process').spawnSync(process.execPath,
    ['--expose-gc', __filename], { stdio: 'inherit' });
  process.exit(r.status);
}
const sleep = () => new Promise((r) => setTimeout(r, 10));
let outerRef;
(function() {
  const ac = new AbortController();
  const inner = AbortSignal.any([ac.signal]);
  const outer = AbortSignal.any([inner]);
  outer.addEventListener('abort', () => {});
  outerRef = new WeakRef(outer);
  globalThis.__keep = new WeakRef(inner);
})();
(async () => {
  for (let i = 0; i < 30; i++) {
    await sleep();
    gc();
  }
  console.log('outer collected:', outerRef.deref() === undefined);
})();
