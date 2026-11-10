if (!process.execArgv.includes('--experimental-stream-iter')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--experimental-stream-iter', '--no-warnings', __filename], { stdio: 'inherit' });
  process.exit(r.status);
}
const { merge } = require('stream/iter');
async function* bad() { throw 0; }
async function* slow() { await new Promise((r) => setTimeout(r, 50)); yield [new Uint8Array(1)]; }
(async () => {
  try {
    let n = 0;
    for await (const b of merge(bad(), slow())) n++;
    console.log('no error, batches:', n);
  } catch (e) {
    console.log('caught:', e);
  }
})();
