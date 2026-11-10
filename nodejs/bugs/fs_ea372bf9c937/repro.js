'use strict';
const { spawnSync } = require('child_process');
const crypto = require('crypto');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--expose-internals', __filename, 'child'],
                      { env: { ...process.env, UV_THREADPOOL_SIZE: '1' }, encoding: 'utf8' });
  process.stdout.write(r.stdout);
  console.log('child exit', r.status);
  return;
}
const { internalBinding } = require('internal/test/binding');
const binding = internalBinding('fs');
crypto.pbkdf2('secret', 'salt', 300_000, 32, 'sha512', () => {});
const req = new binding.FSReqCallback(false);
req.oncomplete = (err) => console.log('stat result:', err?.code ?? 'success');
binding.stat(__filename, false, req, true);
console.log('cancel is', typeof req.cancel);
if (typeof req.cancel === 'function') req.cancel();
