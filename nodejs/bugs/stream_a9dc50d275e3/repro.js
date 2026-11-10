'use strict';
// stream/iter requires --experimental-stream-iter; re-exec with the flag.
if (!process.argv.includes('--child')) {
  const r = require('child_process').spawnSync(
    process.execPath,
    ['--experimental-stream-iter', '--no-warnings', __filename, '--child'],
    { stdio: 'inherit' });
  process.exit(r.status);
}
const { pull, from, text } = require('stream/iter');
(async () => {
  const ac = new AbortController();
  const reason = new Error('aborted during flush');
  const transform = async (chunks) => {
    if (chunks !== null) return chunks;
    ac.abort(reason);
    return null;
  };
  try {
    const r = await text(pull(from('x'), transform, { signal: ac.signal }));
    console.log('resolved:', r);
  } catch (e) {
    console.log('rejected:', e === reason, e.message);
  }
})();
