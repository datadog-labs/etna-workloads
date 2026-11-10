const fs = require('fs'), path = require('path'), os = require('os');
const { run } = require('node:test');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
const f = path.join(dir, 'a.js');
fs.writeFileSync(f, 'throw new Error("x");\n');
const s = run({ files: [f] });
s.on('test:fail', (r) => {
  console.log(r.name === f, r.line, r.column, r.file === f);
});
s.on('close', () => { fs.rmSync(dir, { recursive: true }); });
s.resume();
