const { run } = require('node:test');
const { junit } = require('node:test/reporters');
const fs = require('fs'), os = require('os'), path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
const f = path.join(dir, 't.js');
fs.writeFileSync(f, `const test=require('node:test');
test('failing',(t)=>{t.diagnostic('');throw new Error('error');});`);
let out = '';
const s = run({ files: [f], concurrency: 1 }).compose(junit);
s.on('data', (c) => out += c);
s.on('end', () => {
  console.log(out.includes('<!--  -->') ? 'empty comment emitted' : 'no empty comment');
  fs.rmSync(dir, { recursive: true, force: true });
});
