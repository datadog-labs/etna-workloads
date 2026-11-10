if (!process.execArgv.includes('--no-warnings')) {
  const r = require('child_process').spawnSync(process.execPath, ['--experimental-stream-iter', '--no-warnings', __filename], { stdio: 'inherit' });
  process.exit(r.status);
}
const { push, broadcast } = require('stream/iter');
(async () => {
  for (const name of ['push', 'broadcast']) {
    try {
      let w;
      if (name === 'push') w = push().writer;
      else w = broadcast().writer;
      const ac = new AbortController();
      const reason = new Error('aborted');
      ac.abort(reason);
      try {
        await w.end({ signal: ac.signal });
        console.log(name, 'end resolved');
      } catch (e) {
        console.log(name, 'end rejected', e === reason);
      }
      // writer should remain open if end was rejected
      try { await w.write('x'); console.log(name, 'write ok'); }
      catch (e) { console.log(name, 'write failed', e.code || e.message); }
    } catch (e) { console.log(name, 'setup error', e.message); }
  }
})();
