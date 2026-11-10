'use strict';
const zlib = require('zlib');
if (process.argv[2] === 'child') {
  try {
    zlib.createBrotliCompress().flush(zlib.constants.Z_FINISH);
    console.log('no error');
  } catch (e) { console.log(e.code); }
  process.exit(0);
}
const { spawnSync } = require('child_process');
const r = spawnSync(process.execPath, [__filename, 'child'], { timeout: 5000, encoding: 'utf8' });
console.log(r.error ? 'hang/timeout' : r.stdout.trim());
