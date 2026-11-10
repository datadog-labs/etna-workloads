const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const f = path.join(dir, 'throws.mjs');
fs.writeFileSync(f, 'throw new Error("boom");\n');
try { require(f); } catch (e) { console.log('caught', e.message); }
setTimeout(() => { console.log('done'); fs.rmSync(dir, { recursive: true, force: true }); }, 100);
