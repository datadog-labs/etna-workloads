const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
const f = path.join(dir, 'a');
fs.writeFileSync(f, 'x');
const t = new Date(-86400500);
fs.utimesSync(f, t, t);
for (const bigint of [false, true]) {
  const s = fs.statSync(f, { bigint });
  console.log(bigint, Number(s.mtimeMs), s.mtime.getTime());
}
fs.promises.stat(f, { bigint: true }).then((s) => {
  console.log('promise', Number(s.mtimeMs), s.mtime.getTime());
  fs.rmSync(dir, { recursive: true });
});
