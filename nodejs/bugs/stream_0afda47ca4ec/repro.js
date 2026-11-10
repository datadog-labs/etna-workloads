'use strict';
if (!process.execArgv.includes('--experimental-stream-iter')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--experimental-stream-iter', '--no-warnings', __filename], { stdio: 'inherit' });
  process.exit(r.status);
}
const { share } = require('stream/iter');
const { setImmediate } = require('timers/promises');
(async () => {
  let pulls = 0;
  async function* source() {
    for (let i = 0; i < 7; i++) {
      pulls++;
      const chunk = new Uint8Array(16384);
      chunk[0] = i;
      yield [chunk];
    }
  }
  const shared = share(source(), { budget: 16384, backpressure: 'drop-newest' });
  const fast = shared.pull()[Symbol.asyncIterator]();
  const slow = shared.pull()[Symbol.asyncIterator]();
  await fast.next();
  let settled = false;
  const next = fast.next().then((r) => { settled = true; return r; });
  await setImmediate();
  await setImmediate();
  console.log('pulls', pulls, 'settled', settled);
  const s = await slow.next();
  console.log('slow', s.value[0][0]);
  const n = await next;
  console.log('fast', n.value[0][0], 'pulls', pulls);
  shared.cancel();
})();
