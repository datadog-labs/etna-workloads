'use strict';
if (!process.argv.includes('child')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--expose-internals', __filename, 'child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout); process.stderr.write(r.stderr);
  process.exit(r.status);
}
const webidl = require('internal/webidl');
const conv = webidl.converters.AllowSharedBufferSource ||
  webidl.converters.BufferSource;
function t(name, buf, growableValue) {
  Object.defineProperty(buf, 'growable', { value: growableValue });
  try { conv(buf, { prefix: 'p', context: 'c' }); console.log(name, 'accepted'); }
  catch (e) { console.log(name, 'rejected', e.code); }
}
t('fixed-shadowed-true', new SharedArrayBuffer(4), true);
t('growable-shadowed-false', new SharedArrayBuffer(4, { maxByteLength: 8 }), false);
