const fs = require('fs'), os = require('os'), path = require('path');
const p = path.join(fs.mkdtempSync(path.join(os.tmpdir(), 'r-')), 'w.txt');
const s = fs.createWriteStream(p);
s.on('error', (e) => console.log('error:', e.code || e.message));
s.on('finish', () => console.log('finish:', JSON.stringify(fs.readFileSync(p, 'utf8'))));
s.cork();
s.write('data', () => console.log('write cb'));
s.uncork();
s.end();
