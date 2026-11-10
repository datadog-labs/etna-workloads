const fs = require('fs'), os = require('os'), path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
const f = path.join(d, 'f'); fs.writeFileSync(f, 'x');
const l = path.join(d, 'l'); fs.symlinkSync(f, l);
const fd = fs.openSync(f, 'r');
for (const [n, fn] of [['chown', () => fs.chownSync(f, -1, -1)],
  ['lchown', () => fs.lchownSync(l, -1, -1)],
  ['fchown', () => fs.fchownSync(fd, -1, -1)]]) {
  try { fn(); console.log(n, 'ok'); } catch (e) { console.log(n, 'error', e.code); }
}
fs.closeSync(fd); fs.rmSync(d, { recursive: true });
