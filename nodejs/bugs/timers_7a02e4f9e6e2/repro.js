// Run with GC exposed via re-spawn.
const { spawnSync } = require('child_process');
if (process.argv[2] !== 'child') {
  for (const f of ['--no-async-context-frame', '--async-context-frame']) {
    const r = spawnSync(process.execPath, ['--expose-gc', f, __filename, 'child'], { encoding: 'utf8' });
    process.stdout.write(f + ': ' + r.stdout + r.stderr);
  }
  return;
}
const { AsyncLocalStorage } = require('async_hooks');
const als = new AsyncLocalStorage();
let ref, keep;
function mk() {
  const store = { big: new Array(10) };
  ref = new WeakRef(store);
  als.run(store, () => { keep = setTimeout(() => {}, 1); });
}
mk();
keep.ref?.();
setTimeout(() => {
  setTimeout(() => {
    global.gc();
    setImmediate(() => {
      global.gc();
      console.log('store collected:', ref.deref() === undefined);
    });
  }, 10);
}, 20);
