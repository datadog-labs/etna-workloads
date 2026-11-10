'use strict';
const { spawnSync } = require('child_process');
if (process.argv[2] === 'child') {
  process.stdout.destroy();
  process.stderr.destroy();
  console.log('stdout');
  process.stdout.write('rocks\n');
  console.error('stderr');
  setTimeout(() => process.stderr.write('rocks too\n'), 10);
  return;
}
const r = spawnSync(process.execPath, [__filename, 'child'], { encoding: 'utf8' });
console.log(JSON.stringify({ status: r.status, stdout: r.stdout, stderr: r.stderr }));
