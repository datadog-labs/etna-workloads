const fs = require('fs'), os = require('os'), path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const m = path.join(d, 'node_modules', 'pkg');
fs.mkdirSync(m, { recursive: true });
fs.writeFileSync(path.join(m, 'package.json'), JSON.stringify({ main: 'doesnotexist.js' }));
fs.writeFileSync(path.join(m, 'index.js'), 'module.exports = 1;');
fs.writeFileSync(path.join(d, 'main.js'), 'require("pkg");');
const w = [];
process.removeAllListeners('warning');
process.on('warning', (x) => w.push(x.code));
try { require(path.join(d, 'main.js')); console.log('loaded'); } catch (e) { console.log('error', e.code); }
console.log('warnings', w.length ? 'pending' : 'none');
setImmediate(() => { console.log('warning codes', w.join()); fs.rmSync(d, { recursive: true, force: true }); });
