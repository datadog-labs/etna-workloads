'use strict';
if (!process.execArgv.includes('--experimental-stream-iter')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--no-warnings', '--experimental-stream-iter', __filename], { stdio: 'inherit' });
  process.exit(r.status);
}
const { broadcast } = require('stream/iter');
(async () => {
  for (const reason of [0, '', false, null]) {
    const { broadcast: bc } = broadcast();
    const c = bc.push();
    const p = (async () => {
      try { for await (const _ of c); return 'clean'; } catch (e) { return 'err:' + String(e); }
    })();
    bc.cancel(reason);
    console.log('broadcast', JSON.stringify(reason), await p);
  }
})();
