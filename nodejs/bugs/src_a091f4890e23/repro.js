'use strict';
const { spawnSync } = require('child_process');
if (process.argv[2] === 'child') {
  const { URLPattern } = require('url');
  const proto = Object.getPrototypeOf(new URLPattern());
  const get = Object.getOwnPropertyDescriptor(proto, process.argv[3]).get;
  try { get({}); console.log('no throw'); } catch (e) { console.log('threw', e.message); }
  return;
}
for (const p of ['protocol', 'hostname', 'pathname', 'hasRegExpGroups']) {
  const r = spawnSync(process.execPath, [__filename, 'child', p], { encoding: 'utf8' });
  console.log(p, r.status === 0 ? r.stdout.trim() : 'crashed');
}
