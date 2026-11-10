'use strict';
const { spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const target = path.join(dir, 'target.txt');
fs.writeFileSync(target, 'x');
const child = `
const t = process.env.T, l = process.env.L;
const out = [];
const r = (n, f) => { try { f(); out.push(n + ' ok'); } catch (e) { out.push(n + ' ' + e.code); } };
r('lstat', () => require('fs').lstatSync(t));
r('symlink', () => require('fs').symlinkSync(t, l + '1'));
r('dlopen', () => process.dlopen({exports:{}}, l + 'none.node'));
require('fs').promises.lstat(t).then(() => out.push('plstat ok'), (e) => out.push('plstat ' + e.code)).then(() => {
  console.log(out.join('\\n'));
});
`;
const res = spawnSync(process.execPath, ['--permission-audit', '-e', child], {
  encoding: 'utf8', env: { ...process.env, T: target, L: path.join(dir, 'link') },
});
console.log(res.stdout);
console.log('status', res.status);
fs.rmSync(dir, { recursive: true, force: true });
