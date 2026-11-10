const fs = require('fs'), os = require('os'), path = require('path');
const { spawnSync } = require('child_process');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
fs.writeFileSync(path.join(d, 'dep1.js'), "module.exports = require('assert');\n");
fs.writeFileSync(path.join(d, 'dep2.js'), "exports.assert = require('assert');\n");
fs.writeFileSync(path.join(d, 'main.mjs'),
`import { strictEqual } from 'assert';
import './dep1.js';
import { assert as depAssert } from './dep2.js';
strictEqual(depAssert.strictEqual, strictEqual);
console.log('ok');
`);
const r = spawnSync(process.execPath, [path.join(d, 'main.mjs')], { encoding: 'utf8' });
console.log('status', r.status);
console.log(r.stdout);
console.log((r.stderr.match(/^\w*Error.*$/m) || [''])[0]);
fs.rmSync(d, { recursive: true, force: true });
