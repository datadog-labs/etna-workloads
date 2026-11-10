if (!process.argv[2]) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--experimental-stream-iter', '--no-warnings', __filename, 'x'], { encoding: 'utf8' });
  process.stdout.write(r.stdout + r.stderr);
  process.exit(r.status);
}
const { share } = require('stream/iter');
const { getEventListeners } = require('events');
(async () => {
  const c = new AbortController();
  const reason = new Error('aborted');
  const s = share('x', { signal: c.signal });
  const fast = s.pull()[Symbol.asyncIterator]();
  const slow = s.pull()[Symbol.asyncIterator]();
  await fast.next(); await fast.next();
  console.log('listeners', getEventListeners(c.signal, 'abort').length);
  c.abort(reason);
  try { await slow.next(); console.log('slow: no error'); }
  catch (e) { console.log('slow rejected with reason:', e === reason); }
})();
