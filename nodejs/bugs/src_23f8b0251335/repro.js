const { spawnSync } = require('child_process');
const r = spawnSync(process.execPath, ['--prof-process', '--preprocess', 'nonexistent.log'], { encoding: 'utf8' });
console.log('bad option reported:', /bad option/.test(r.stderr));
console.log('reached tick processor:', /Cannot access log file/.test(r.stderr + r.stdout));
