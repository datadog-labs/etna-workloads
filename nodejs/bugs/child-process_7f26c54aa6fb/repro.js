'use strict';
const { spawnSync } = require('child_process');
if (process.argv[2] === 'parent') {
  const r = spawnSync(process.execPath, ['-e', 'console.log(typeof process.permission)'],
    { encoding: 'utf8', env: { ...process.env, NODE_OPTIONS: '--title=--permission' } });
  console.log('child:', r.stdout.trim());
} else {
  const r = spawnSync(process.execPath, ['--permission', '--allow-child-process', '--allow-fs-read=*', __filename, 'parent'], { encoding: 'utf8' });
  process.stdout.write(r.stdout);
  console.log('exit', r.status);
}
