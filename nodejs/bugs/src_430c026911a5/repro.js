const { spawnSync } = require('child_process');
const r = spawnSync(process.execPath, ['--permission', '--inspect-brk=0', '--eval', 'console.log("Hi!")'],
  { timeout: 8000, encoding: 'utf8' });
console.log('denied:', /Error: Access to this API has been restricted/.test(r.stderr));
console.log('status:', r.status);
console.log('stdout:', JSON.stringify(r.stdout));
