const fs = require('fs');
const path = require('path');
const os = require('os');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const f = path.join(dir, 'late.js');
try { require(f); } catch (e) { console.log('first:', e.code); }
fs.writeFileSync(f, 'module.exports = 42;');
try { console.log('second:', require(f)); } catch (e) { console.log('second:', e.code); }
fs.rmSync(dir, { recursive: true, force: true });
