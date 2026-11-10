const { spawnSync } = require('child_process');
const r = spawnSync(process.execPath, ['--permission', '--allow-fs-read=*', '-e',
  `try { process.binding('fs'); console.log('binding allowed'); } catch (e) { console.log(e.code); }`],
  { encoding: 'utf8' });
console.log(r.stdout.trim(), r.status);
