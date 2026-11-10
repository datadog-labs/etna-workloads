const fs = require('fs'), os = require('os'), path = require('path');
const f = path.join(fs.mkdtempSync(path.join(os.tmpdir(), 'r-')), 'a.txt');
const s = fs.createWriteStream(f, { emitClose: true });
let n = 0;
s.on('close', () => n++);
s.end('hi');
setTimeout(() => { console.log('close events:', n); fs.rmSync(path.dirname(f), { recursive: true }); }, 300);
