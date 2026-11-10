const { spawnSync } = require('child_process');
const r = spawnSync(process.execPath, ['--v8-pool-size=0', '--expose-gc', '-e',
  "globalThis.gc(); console.log('ok')"],
  { encoding: 'utf8', timeout: 8000 });
console.log(r.error ? 'timeout/error' : 'finished', r.status, r.signal, r.stdout.trim());
