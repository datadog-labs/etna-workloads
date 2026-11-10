const fs = require('fs'), os = require('os'), path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
const f = path.join(d, 'x.json');
try { require(f); } catch (e) { console.log(e.code); }
fs.writeFileSync(f, '[]');
try { console.log(require(f)); } catch (e) { console.log(e.code); }
fs.rmSync(d, { recursive: true });
