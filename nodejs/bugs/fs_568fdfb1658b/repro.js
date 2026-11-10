const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const f = path.join(dir, 'a.txt');
const ev = [];
const s = fs.createWriteStream(f);
for (const e of ['open', 'ready', 'finish', 'close', 'error']) s.on(e, () => ev.push(e));
s.end('hello', () => ev.push('end-cb'));
s.on('close', () => {
  console.log(ev.join(','));
  console.log('destroyed:', s.destroyed, 'closed:', s.closed);
  fs.rmSync(dir, { recursive: true });
});
