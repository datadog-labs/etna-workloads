const { spawnSync } = require('child_process');
const r = spawnSync(process.execPath, ['--v8-options'], { encoding: 'utf8' });
const m = /default: (--external-memory-max-reasonable-size=\S+)$/m.exec(r.stdout);
console.log(m ? m[1] : 'not found');
