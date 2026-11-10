const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'rmsync-'));
const f = path.join(dir, 'héllo-日本語-ü.txt');
fs.writeFileSync(f, 'x');
try { fs.rmSync(f); console.log('rm ok'); } catch (e) { console.log('rm error', e.code); }
console.log('exists after:', fs.existsSync(f));
const d = path.join(dir, 'dïr-é');
fs.mkdirSync(d);
try { fs.rmSync(d); } catch (e) { console.log(e.code, e.message.includes('dïr-é')); }
try { fs.rmSync(d, { recursive: true }); } catch (e) { console.log('rec error', e.code); }
console.log('dir exists after:', fs.existsSync(d));
fs.rmSync(dir, { recursive: true, force: true });
