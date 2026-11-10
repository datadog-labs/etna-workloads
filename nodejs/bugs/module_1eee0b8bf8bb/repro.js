const fs = require('fs'), os = require('os'), path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
fs.writeFileSync(path.join(d, 'package.json'), JSON.stringify({ imports: { '#dep': './dep.js' } }));
fs.writeFileSync(path.join(d, 'dep.js'), 'module.exports = "dep ok";');
fs.writeFileSync(path.join(d, 'main.js'), 'try { console.log(require("#dep")); } catch (e) { console.log(e.code); }');
require(path.join(d, 'main.js'));
fs.rmSync(d, { recursive: true, force: true });
