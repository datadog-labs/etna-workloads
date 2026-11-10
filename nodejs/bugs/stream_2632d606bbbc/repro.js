if (!process.execArgv.includes('--experimental-stream-iter')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--no-warnings', '--experimental-stream-iter', __filename], { stdio: 'inherit' });
  process.exit(r.status);
}
const { push } = require('stream/iter');
const reason = { custom: 'reason' };
const ac = new AbortController();
const { writer, readable } = push({ signal: ac.signal });
(async () => {
  ac.abort(reason);
  try {
    for await (const _ of readable) {}
    console.log('no error');
  } catch (e) {
    console.log(e === reason, e && e.name);
  }
  try { await writer.write('x'); console.log('write ok'); }
  catch (e) { console.log('write', e === reason, e && e.name); }
})();
