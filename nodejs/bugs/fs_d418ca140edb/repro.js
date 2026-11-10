const fs = require('fs');
const path = require('path');
const os = require('os');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'rw-'));
const missing = path.join(dir, 'missing');
for (const opts of [{}, { throwIfNoEntry: true }, { throwIfNoEntry: false }]) {
  try {
    const w = fs.watch(missing, { recursive: true, ...opts });
    console.log(JSON.stringify(opts), 'no throw');
    w.close();
  } catch (e) {
    console.log(JSON.stringify(opts), 'threw', e.code, e.filename === missing);
  }
}
fs.rmSync(dir, { recursive: true });
