const { spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const f = path.join(dir, 'a.test.js');
fs.writeFileSync(f, `
const test = require('node:test');
test('x', () => {
  process.stdout.write(Buffer.from([0xff,0x0f,0,0,0,4,1,2,3,4,0x41,0x42,0x43,0x44]));
});
`);
const r = spawnSync(process.execPath, ['--test', '--test-reporter=tap', f], { encoding: 'utf8' });
const out = r.stdout + r.stderr;
console.log('exit', r.status);
console.log('has ok 1:', /^ok 1 /m.test(out));
console.log('crashed:', /Error|deserializ/i.test(r.stderr));
fs.rmSync(dir, { recursive: true, force: true });
