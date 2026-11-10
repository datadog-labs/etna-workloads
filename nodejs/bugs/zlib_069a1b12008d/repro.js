'use strict';
process.removeAllListeners('warning');
const zlib = require('zlib');
const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'zr-'));
const file = path.join(dir, 'p.zip');
const payload = Buffer.alloc(8 * 1024 * 1024, 0x61);
const chunks = [];
for (const c of zlib.createZipArchiveSync([zlib.ZipEntry.createSync('big', payload, { method: 'store' })])) chunks.push(c);
fs.writeFileSync(file, Buffer.concat(chunks));
(async () => {
  const zf = zlib.ZipFile.openSync(file);
  const it = zf.getSync('big').contentIterator();
  const first = await it.next();
  console.log('first done:', first.done);
  const result = await Promise.race([
    zf.close().then(() => 'closed'),
    new Promise((r) => setTimeout(() => r('close still pending'), 1500)),
  ]);
  console.log(result);
  fs.rmSync(dir, { recursive: true, force: true });
  process.exit(result === 'closed' ? 0 : 1);
})();
