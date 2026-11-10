if (!process.execArgv.includes('--experimental-stream-iter')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--experimental-stream-iter', '--no-warnings', __filename], { stdio: 'inherit' });
  process.exit(r.status);
}
const { broadcast } = require('stream/iter');
(async () => {
  const { writer, broadcast: bc } = broadcast({ budget: 8, backpressure: 'strict' });
  const it = bc.push()[Symbol.asyncIterator]();
  let ok = 0;
  for (let i = 0; i < 1000; i++) if (writer.writeSync('')) ok++;
  console.log('empty writes accepted:', ok);
  console.log('write a:', writer.writeSync('a'));
  writer.endSync();
  let batches = 0;
  for (;;) { const r = await it.next(); if (r.done) break; batches++; }
  console.log('batches:', batches);
})();
