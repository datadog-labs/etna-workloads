const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'rp-'));
const f = path.join(dir, 'f.txt');
fs.writeFileSync(f, 'x'.repeat(100));
const s = fs.createReadStream(f, { start: 10, end: 59, highWaterMark: 20 });
const log = [];
s.on('open', () => log.push('pos at open ' + s.pos));
s.once('readable', () => log.push('pos at first readable ' + s.pos + ' bytesRead ' + s.bytesRead));
let total = 0;
s.on('data', (c) => { total += c.length; log.push('data ' + c.length + ' pos ' + s.pos); });
s.on('end', () => {
  log.push('end total ' + total + ' pos ' + s.pos + ' bytesRead ' + s.bytesRead);
  console.log(log.join('\n'));
  fs.rmSync(dir, { recursive: true });
});
