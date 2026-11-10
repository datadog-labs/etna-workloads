const fs = require('fs');
const path = require('path');
const os = require('os');
const p = path.join(os.tmpdir(), 'definitely-missing-file-xyz-blob');
try {
  fs.openAsBlob(p);
  console.log('no throw');
} catch (e) {
  console.log(e.name, e.code, e.errno, e.syscall, e.path === p);
}
