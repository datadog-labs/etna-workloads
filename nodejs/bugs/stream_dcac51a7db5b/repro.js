if (!process.env.SPAWNED) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--experimental-stream-iter', __filename],
    { env: { ...process.env, SPAWNED: '1' }, encoding: 'utf8' });
  process.stdout.write(r.stdout + r.stderr);
  process.exit(r.status);
}
const { pull } = require('stream/iter');
(async () => {
  const log = (...a) => console.log(...a);
  // 1. pre-aborted signal
  const ac = new AbortController();
  ac.abort(new Error('boom'));
  let it;
  try {
    it = pull(['a'], { signal: ac.signal });
    log('no sync throw');
  } catch (e) { log('sync throw', e.message); }
  if (it) {
    for (let i = 0; i < 2; i++) {
      try { const r = await it[Symbol.asyncIterator]().next(); log('resolved', JSON.stringify(r)); }
      catch (e) { log('rejected', e.message); }
    }
  }
  // 2. abort mid-stream, later pulls
  const ac2 = new AbortController();
  async function* src() { yield ['a']; await new Promise(() => {}); }
  const it2 = pull(src(), { signal: ac2.signal })[Symbol.asyncIterator]();
  log('first', JSON.stringify(await it2.next()));
  const p = it2.next();
  ac2.abort(new Error('stop'));
  try { await p; log('p resolved'); } catch (e) { log('p rejected', e.message); }
  for (let i = 0; i < 2; i++) {
    try { log('later', JSON.stringify(await it2.next())); }
    catch (e) { log('later rejected', e.message); }
  }
})();
