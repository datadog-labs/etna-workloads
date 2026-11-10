const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const f = path.join(dir, 'x.txt');
fs.writeFileSync(f, 'hello');
// flag 'wx' on an existing file must fail with EEXIST
fs.readFile(f, { flag: 'wx' }, (err, data) => {
  console.log(err ? err.code : 'no error: ' + data);
  fs.rmSync(dir, { recursive: true, force: true });
});
