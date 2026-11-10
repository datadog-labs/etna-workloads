if (!process.argv.includes('--child')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--experimental-vfs', __filename, '--child'], { stdio: 'inherit' });
  process.exit(r.status);
}
process.emitWarning = () => {};
const fs = require('fs');
const path = require('path');
const vfs = require('node:vfs');
const v = vfs.create();
v.mkdirSync('/src', { recursive: true });
const mp = v.mount();
const p = path.join(mp, 'missing');
const show = (e) => e ? `${e.code}/${e.syscall}` : 'no error';
try { fs.statfsSync(p); console.log('sync: no error'); } catch (e) { console.log('sync:', show(e)); }
fs.promises.statfs(p).then(() => console.log('promise: no error'), (e) => console.log('promise:', show(e)))
  .then(() => {
    try {
      fs.statfs(p, (e) => { console.log('cb:', show(e)); v.unmount(); });
    } catch (e) { console.log('cb threw sync:', show(e)); v.unmount(); }
  });
