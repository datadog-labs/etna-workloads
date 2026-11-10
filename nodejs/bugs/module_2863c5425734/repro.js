const fs = require('fs'), os = require('os'), path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
fs.writeFileSync(path.join(d, 'a.mjs'), "export { b } from './b.mjs';\n");
fs.writeFileSync(path.join(d, 'b.mjs'), "import './a.mjs';\nexport const b = 5;\n");
fs.writeFileSync(path.join(d, 'c.cjs'), "module.exports = require('./a.mjs');\n");
try {
  const m = require(path.join(d, 'c.cjs'));
  console.log('ok', m.b);
} catch (e) {
  console.log('error', e.code, String(e.message).split('\n')[0].replace(d, '<dir>'));
}
fs.rmSync(d, { recursive: true, force: true });
