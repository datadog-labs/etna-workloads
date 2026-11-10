if (!process.execArgv.includes('--experimental-stream-iter')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--experimental-stream-iter', '--no-warnings', __filename], { stdio: 'inherit' });
  process.exit(r.status);
}
const { Readable } = require('stream');
const { from } = require('stream/iter');
(async () => {
  const r = new Readable({ read() {} });
  const it = from(r)[Symbol.asyncIterator]();
  console.log(JSON.stringify(await it.return('stopped')));
  console.log('destroyed after return before next:', r.destroyed);

  const r2 = new Readable({ read() {} });
  const it2 = from(r2)[Symbol.asyncIterator]();
  it2.next();
  await new Promise((res) => setImmediate(res));
  const ret = it2.return('x');
  const t = new Promise((res) => setTimeout(res, 500, 'timeout'));
  console.log('return while pending:', await Promise.race([ret.then(() => 'settled'), t]));
  process.exit(0);
})();
