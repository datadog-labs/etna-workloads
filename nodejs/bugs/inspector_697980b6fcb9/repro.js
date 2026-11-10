'use strict';
// The --test process-isolation runner process has should_create_inspector()==false,
// so a Worker started from a custom reporter has no parent inspector handle.
const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
fs.writeFileSync(path.join(dir, 'rep.js'), `
const { Worker } = require('worker_threads');
new Worker(\`
const i = require('inspector');
const s = new i.Session();
try { s.connectToMainThread(); console.log('connected'); }
catch (e) { console.log('caught', e.code); }
\`, { eval: true, execArgv: [] });
module.exports = async function* (src) { for await (const e of src); };
`);
fs.writeFileSync(path.join(dir, 't.test.js'), "require('node:test')('x', () => {});\n");
const r = spawnSync(process.execPath,
  ['--test', '--test-reporter=./rep.js', 't.test.js'], { cwd: dir, encoding: 'utf8' });
console.log('stdout:', JSON.stringify(r.stdout.trim()));
console.log('aborted:', /Assertion failed/.test(r.stderr) || r.signal !== null);
console.log('status:', r.status === 0 ? 'ok' : 'failed');
fs.rmSync(dir, { recursive: true, force: true });
