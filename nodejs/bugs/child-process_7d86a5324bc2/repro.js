'use strict';
const { spawnSync } = require('child_process');
if (process.argv[2] !== 'inner') {
  const r = spawnSync(process.execPath, ['--expose-internals', __filename, 'inner'], { encoding: 'utf8' });
  console.log('status', r.status);
  console.log(r.stdout.trim());
  process.exit(0);
}
const { internalBinding } = require('internal/test/binding');
class Dummy { initialize(t) { this.t = t; } }
Dummy.REQUEST = Symbol();
internalBinding('http_parser').HTTPParser = Dummy;
require('child_process');
const { parsers } = require('_http_common');
const p = parsers.alloc();
console.log('patched parser used:', p instanceof Dummy);
