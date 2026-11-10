const cp = require('child_process');
const r = cp.spawnSync('pwd', undefined, { encoding: 'utf8', cwd: '/' });
console.log('spawnSync pwd', JSON.stringify(r.stdout));
const r2 = cp.spawnSync('sh', undefined, { encoding: 'utf8', input: 'echo $FOO\n', env: { FOO: 'bar' } });
console.log('spawnSync env', JSON.stringify(r2.stdout));
