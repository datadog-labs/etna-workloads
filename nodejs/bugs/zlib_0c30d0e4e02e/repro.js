// Run with --expose-gc via re-spawn if needed
if (typeof gc !== 'function') {
  const r = require('child_process').spawnSync(process.execPath, ['--expose-gc', __filename], { stdio: 'inherit' });
  process.exit(r.status);
}
const zlib = require('zlib');
const { FinalizationRegistry: FR } = globalThis;
let collected = false;
const reg = new FR(() => { collected = true; });
(function () {
  const strm = zlib.createInflate();
  reg.register(strm, 1);
  strm.once('error', () => {});
  strm.end(Buffer.from('foobar'));
})();
let n = 0;
(function tick() {
  gc();
  if (collected || ++n > 30) {
    console.log('collected:', collected);
    return;
  }
  setTimeout(tick, 20);
})();
