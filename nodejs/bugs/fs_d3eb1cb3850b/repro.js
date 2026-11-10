const fs = require('fs'), os = require('os'), path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
fs.mkdirSync(path.join(d, 'parent/child'), { recursive: true });
fs.writeFileSync(path.join(d, 'parent/child/test.tmp'), 'test');
process.on('uncaughtException', (e) => { console.log('uncaught', e.code); process.exit(1); });
const w = fs.watch(path.join(d, 'parent'), { recursive: true }, () => {
  if (fs.readdirSync(path.join(d, 'parent')).length === 0) w.close();
});
setTimeout(() => {
  fs.rm(path.join(d, 'parent/child'), { recursive: true }, () => {
    setTimeout(() => { w.close(); console.log('ok'); fs.rmSync(d, { recursive: true, force: true }); }, 1000);
  });
}, 500);
