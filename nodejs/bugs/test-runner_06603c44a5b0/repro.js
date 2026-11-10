const { spawnSync } = require('child_process');
const fs = require('fs'), os = require('os'), path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const f = path.join(dir, 't.js');
fs.writeFileSync(f, `
const test = require('node:test');
test('async activity', () => { setTimeout(() => { throw new Error('boom'); }, 50); });
`);
const r = spawnSync(process.execPath, [f], { encoding: 'utf8' });
fs.rmSync(dir, { recursive: true, force: true });
console.log('exit status:', r.status);
console.log('fail line:', /^# fail 1$/m.test(r.stdout));
console.log('diag:', /generated asynchronous activity after the test ended/.test(r.stdout));
