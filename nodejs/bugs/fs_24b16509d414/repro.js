const fs = require('fs');
const os = require('os');
const path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'cp-'));
const src = path.join(d, 'src'), dest = path.join(d, 'dest');
fs.mkdirSync(src); fs.writeFileSync(path.join(src, 'a.txt'), 'a');
fs.mkdirSync(dest);
fs.cp(src, dest, { recursive: true, force: false, errorOnExist: true }, (err) => {
  console.log(err ? err.code : 'no error');
  console.log(fs.existsSync(path.join(dest, 'a.txt')));
  fs.rmSync(d, { recursive: true, force: true });
});
