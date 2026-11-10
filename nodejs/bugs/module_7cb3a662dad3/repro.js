const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const f = path.join(dir, 'tla.mjs');
fs.writeFileSync(f, 'await 1;\nexport const hello = "world";\n');
try { require(f); } catch (e) { console.log('require:', e.code); }
import(f).then((ns) => console.log('import ok', ns.hello),
  (e) => console.log('import failed:', e.name));
