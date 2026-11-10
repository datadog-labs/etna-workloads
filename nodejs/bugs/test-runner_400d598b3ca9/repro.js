const { run } = require('node:test');
const { junit } = require('node:test/reporters');
const fs = require('fs'), os = require('os'), path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
const f = path.join(d, 'a.test.js');
fs.writeFileSync(f, `const { suite, test } = require('node:test');
suite('Outer', () => { suite('Inner', () => { test('t', () => {}); }); });`);
let out = '';
const s = run({ files: [f], isolation: 'none' }).compose(junit);
s.on('data', (c) => out += c);
s.on('end', () => {
  fs.rmSync(d, { recursive: true, force: true });
  console.log(out.match(/classname="[^"]*"/g).join('\n'));
});
