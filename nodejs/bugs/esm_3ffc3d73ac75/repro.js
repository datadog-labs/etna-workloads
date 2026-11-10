const { spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
fs.writeFileSync(path.join(d, 'hook.js'), `require('module').registerHooks({ load(u, c, n) { return n(u, c); } });`);
fs.writeFileSync(path.join(d, 'tla.mjs'), `await Promise.resolve('1');`);
fs.writeFileSync(path.join(d, 'main.js'), `
for (let i = 0; i < 2; i++) {
  try { require('./tla.mjs'); } catch (e) { console.log('code', e.code); }
}`);
const r = spawnSync(process.execPath, ['--import', 'file://' + path.join(d, 'hook.js'), path.join(d, 'main.js')], { encoding: 'utf8' });
console.log('status', r.status);
console.log(r.stdout);
console.log((r.stderr.match(/TypeError.*|ERR_\w+/g) || []).join('\n'));
fs.rmSync(d, { recursive: true, force: true });
