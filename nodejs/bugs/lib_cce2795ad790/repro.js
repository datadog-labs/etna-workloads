// Run with --expose-gc via re-spawn
if (!global.gc) {
  const r = require('child_process').spawnSync(process.execPath, ['--expose-gc', __filename], { encoding: 'utf8' });
  process.stdout.write(r.stdout); process.stderr.write(r.stderr);
  process.exit(r.status);
}
let any;
(function () {
  const c = new AbortController();
  any = AbortSignal.any([c.signal]);
  c.abort(new Error('boom'));
})();
setTimeout(() => {
  gc();
  setTimeout(() => {
    gc();
    console.log('aborted:', any.aborted);
    console.log('reason:', any.reason && any.reason.message);
  }, 50);
}, 50);
