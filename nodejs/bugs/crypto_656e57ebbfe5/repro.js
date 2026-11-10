'use strict';
const { spawnSync } = require('child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--expose-internals', __filename, 'child'], { encoding: 'utf8' });
  console.log(r.stdout.trim());
  console.log('exit', r.status);
  return;
}
const crypto = require('crypto');
const { kHandle } = require('internal/crypto/util');
const h = crypto.createHash('sha256');
h[kHandle] = { update: () => false, digest: () => Buffer.from('') };
h.on('error', (err) => console.log('error event:', err.code));
h.on('finish', () => console.log('finish'));
h.write('test data');
h.end();
