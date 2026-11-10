const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
const f = path.join(dir, 'a.txt');
fs.writeFileSync(f, 'x');
const fd = fs.openSync(f, 'r');
function t(name, fn) {
  try { const s = fn(); s.on('error', () => {}); s.destroy(); console.log(name, 'no error'); }
  catch (e) { console.log(name, e.code); }
}
t('read fd+handle', () => fs.createReadStream(null, { fd, autoClose: false, windowsHandle: 1n }));
t('write fd+handle', () => fs.createWriteStream(null, { fd, autoClose: false, windowsHandle: 1n }));
t('read handle', () => fs.createReadStream(f, { windowsHandle: 1n }));
t('write handle', () => fs.createWriteStream(f, { windowsHandle: 1n }));
fs.closeSync(fd);
fs.rmSync(dir, { recursive: true });
