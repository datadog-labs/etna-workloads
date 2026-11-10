'use strict';
const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const fd = fs.openSync(path.join(dir, 't.txt'), 'w+');
try {
  fs.writeSync(fd, Buffer.alloc(0), -1);
  console.log('no error');
} catch (e) {
  console.log('writeSync:', e.code);
}
try {
  fs.write(fd, Buffer.alloc(0), -1, () => {});
  console.log('no error');
} catch (e) {
  console.log('write:', e.code);
}
fs.closeSync(fd);
fs.rmSync(dir, { recursive: true });
