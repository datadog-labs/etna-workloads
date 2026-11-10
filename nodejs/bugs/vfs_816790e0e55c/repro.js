'use strict';
if (!process.argv.includes('--child')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--experimental-vfs', '--disable-warning=ExperimentalWarning', __filename, '--child'],
    { encoding: 'utf8' });
  process.stdout.write(r.stdout + r.stderr);
  process.exit(r.status);
}
const { create } = require('node:vfs');
const fs = create();
fs.mkdirSync('/a/b', { recursive: true });
fs.symlinkSync('/a/b', '/alias');
try {
  fs.renameSync('/a', '/alias/moved');
  console.log('rename succeeded');
} catch (e) {
  console.log('error', e.code);
}
console.log(fs.readdirSync('/'));
