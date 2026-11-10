'use strict';
const { spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'junit-'));
const f = path.join(dir, 't.js');
fs.writeFileSync(f, `const test = require('node:test');
test('quote"only', () => {});
test('quote&quot;only', () => {});
test('amp&and"quote"', () => {});
test('lt<and"quote', () => {});
test('line\\n"break', () => {});
`);
const r = spawnSync(process.execPath, ['--test', '--test-reporter=junit', f], { encoding: 'utf8', cwd: dir });
fs.rmSync(dir, { recursive: true, force: true });
for (const l of r.stdout.split('\n')) {
  const m = /<testcase name="(.*?)" time=/.exec(l);
  if (m) console.log(m[1]);
}
console.log('status', r.status);
