'use strict';
const { spawnSync } = require('child_process');
const code = 'console.log(RegExp.$_ + "|" + RegExp.lastMatch + "|" + RegExp.$1 + "|" + RegExp.input)';
for (const args of [[], ['--input-type=module']]) {
  const r = spawnSync(process.execPath, ['-e', code, ...args], { encoding: 'utf8' });
  console.log(JSON.stringify(r.stdout), r.status);
}
const f = require('path').join(require('os').tmpdir(), 'repro464.js');
require('fs').writeFileSync(f, code);
const r = spawnSync(process.execPath, [f], { encoding: 'utf8' });
console.log(JSON.stringify(r.stdout), r.status);
