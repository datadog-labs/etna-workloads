const fs = require('fs');
const os = require('os');
const path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const src = path.join(d, 'src'), dest = path.join(d, 'dest');
fs.mkdirSync(path.join(src, 'real'), { recursive: true });
fs.writeFileSync(path.join(src, 'real', 'a.txt'), 'hi');
fs.writeFileSync(path.join(src, 'f.txt'), 'file');
fs.symlinkSync(path.join(src, 'f.txt'), path.join(src, 'link-file'));
fs.symlinkSync(path.join(src, 'real'), path.join(src, 'link-dir'));
fs.cpSync(src, dest, { recursive: true, dereference: true });
for (const n of ['link-file', 'link-dir']) {
  console.log(n, fs.lstatSync(path.join(dest, n)).isSymbolicLink() ? 'symlink' : 'copied');
}
fs.rmSync(d, { recursive: true, force: true });
