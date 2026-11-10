if (process.argv[2] !== 'child') {
  const r = require('child_process').spawnSync(process.execPath,
    ['--no-warnings', '--experimental-stream-iter', __filename, 'child'], { stdio: 'inherit' });
  process.exit(r.status);
}
const { broadcast, share, from } = require('stream/iter');
const ac = new AbortController(); ac.abort();
const { writer, broadcast: b } = broadcast();
console.log('before', b.consumerCount);
const it = b.push({ signal: ac.signal });
console.log('after push', b.consumerCount);
(async () => {
  try { for await (const _ of it); } catch (e) { console.log('err', e.name); }
  console.log('after iterate', b.consumerCount);
  const s = share(from(['a']));
  console.log('share before', s.consumerCount);
  const it2 = s.pull({ signal: ac.signal });
  console.log('share after pull', s.consumerCount);
  try { for await (const _ of it2); } catch (e) { console.log('err', e.name); }
  console.log('share after iterate', s.consumerCount);
})();
