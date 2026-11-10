'use strict';
const { spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--expose-internals', __filename, 'child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout); process.stderr.write(r.stderr);
  process.exit(r.status);
}
const { FilesWatcher } = require('internal/watch_mode/files_watcher');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'fw-'));
const file = path.join(dir, 'a.js');
fs.writeFileSync(file, '0');
const w = new FilesWatcher({ debounce: 20, mode: 'filter' });
w.filterFile(file);
let changes = 0;
w.on('changed', () => { changes++; });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
(async () => {
  await sleep(200);
  for (let i = 1; i <= 3; i++) {
    const before = changes;
    fs.unlinkSync(file);
    fs.writeFileSync(file, String(i));
    await sleep(600);
    console.log(`replacement ${i} detected: ${changes > before}`);
  }
  w.clear();
  fs.rmSync(dir, { recursive: true, force: true });
  process.exit(0);
})();
