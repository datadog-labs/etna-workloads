const fs = require('fs'), os = require('os'), path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'tla-'));
const f = path.join(d, 'tla.mjs');
fs.writeFileSync(f, 'await Promise.resolve(1);\nexport default 1;\n');
for (let i = 0; i < 3; i++) {
  try { require(f); console.log(i, 'loaded'); }
  catch (e) { console.log(i, e.code); }
}
fs.rmSync(d, { recursive: true, force: true });
