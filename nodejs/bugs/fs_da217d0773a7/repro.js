const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
const f = path.join(dir, 'a');
fs.writeFileSync(f, 'x');
function t(label, fn) {
  try { fn(); console.log(label, 'ok'); } catch (e) { console.log(label, e.code); }
}
for (const m of [-1, 1.5, NaN, 2 ** 32, Infinity, -0, '-1', '0o7']) {
  t('chmod ' + String(m), () => fs.chmodSync(f, m));
}
for (const fl of [1.5, NaN, 2 ** 32, -(2 ** 31) - 1, Infinity]) {
  t('open flag ' + String(fl), () => fs.closeSync(fs.openSync(f, fl)));
}
t('open mode 1.5', () => fs.closeSync(fs.openSync(f, 'r', 1.5)));
t('umask 1.5', () => process.umask(1.5));
fs.rmSync(dir, { recursive: true });
