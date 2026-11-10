if (!process.execArgv.includes('--experimental-vfs')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--experimental-vfs', '--no-warnings', __filename], { encoding: 'utf8' });
  process.stdout.write(r.stdout);
  process.exitCode = r.status;
  return;
}
const fs = require('fs');
const path = require('path');
const vfs = require('node:vfs');
const v = vfs.create();
v.writeFileSync('/t.txt', 'x');
v.symlinkSync('/t.txt', '/l.txt');
const mp = v.mount();
try {
  fs.lchownSync(path.join(mp, 'l.txt'), 123, 456);
  const t = fs.lstatSync(path.join(mp, 't.txt'));
  const l = fs.lstatSync(path.join(mp, 'l.txt'));
  console.log('target', t.uid, t.gid);
  console.log('link', l.uid, l.gid);
} catch (e) { console.log('error', e.code); }
finally { v.unmount(); }
