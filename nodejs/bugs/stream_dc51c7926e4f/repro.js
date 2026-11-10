if (!process.execArgv.includes('--experimental-stream-iter')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--no-warnings', '--experimental-stream-iter', __filename], { stdio: 'inherit' });
  process.exit(r.status);
}
const { broadcast } = require('stream/iter');
const timeout = (ms) => new Promise((r) => setTimeout(() => r('TIMEOUT'), ms));
(async () => {
  const { writer, broadcast: bc } = broadcast({ budget: 16384, backpressure: 'unbounded' });
  const iter = bc.push()[Symbol.asyncIterator]();
  await writer.write(new Uint8Array(16384).fill(65));
  let state = 'pending';
  const pw = writer.write(Uint8Array.of(66)).then(() => { state = 'resolved'; },
                                                   (e) => { state = 'rejected: ' + e.message; });
  const endPromise = writer.end();
  const out = [];
  for (let i = 0; i < 3; i++) {
    const r = await Promise.race([iter.next(), timeout(1000)]);
    out.push(r === 'TIMEOUT' ? r : r.done ? 'done' : r.value[0][0]);
    if (r.done) break;
  }
  console.log('items:', out.join(','));
  await Promise.race([pw, timeout(200)]);
  console.log('pending write:', state);
  console.log('end:', await Promise.race([endPromise, timeout(500)]));
})();
