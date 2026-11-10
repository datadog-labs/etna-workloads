'use strict';
const { spawnSync } = require('node:child_process');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const fx = path.join(dir, 't.js');
fs.writeFileSync(fx, `
const { test } = require('node:test');
test('pass', () => {});
test('pass2', () => {});
test('fail', () => { throw new Error('x'); });
setInterval(() => {}, 1000);
`);
const out = path.join(dir, 'out.txt');
const c = spawnSync(process.execPath, ['--test-force-exit', '--test-reporter=tap',
  `--test-reporter-destination=${out}`, fx]);
const o = fs.existsSync(out) ? fs.readFileSync(out, 'utf8') : '';
console.log('status', c.status);
console.log('has tests', /# tests 3/.test(o), 'has pass', /# pass 2/.test(o), 'has fail', /# fail 1/.test(o));
fs.rmSync(dir, { recursive: true, force: true });
