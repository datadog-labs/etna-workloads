const { spawnSync } = require('child_process');
const r = spawnSync(process.execPath, ['--no-warnings', '--experimental-loader',
  'data:text/javascript,', '--eval', 'setTimeout(() => console.log("hello"),99)'],
  { encoding: 'utf8', timeout: 15000 });
console.log('stdout:', JSON.stringify(r.stdout));
console.log('stderr empty:', r.stderr === '');
console.log('status:', r.status, 'signal:', r.signal);
