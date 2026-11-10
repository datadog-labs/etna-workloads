'use strict';
if (!process.argv.includes('--child')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--expose-gc', '--no-concurrent-array-buffer-sweeping', __filename, '--child'],
    { stdio: 'inherit' });
  process.exit(r.status);
}
const MiB = 1024 * 1024;
const sleep = () => new Promise((r) => setImmediate(r));
async function gc() { for (let i = 0; i < 3; i++) { global.gc(); await sleep(); } }
(async () => {
  const buffer = Buffer.alloc(MiB);
  await gc();
  const before = process.memoryUsage().arrayBuffers;
  for (let i = 0; i < 64; i++) new Blob([buffer]).stream();
  await gc();
  const retained = process.memoryUsage().arrayBuffers - before;
  console.log(retained < 16 * MiB ? 'no leak' : 'leak');
})();
