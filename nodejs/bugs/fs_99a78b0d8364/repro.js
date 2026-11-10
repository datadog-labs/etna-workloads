const fs = require('fs');
const os = require('os');
const path = require('path');
const cp = require('child_process');
if (process.argv[2] === 'child') {
  console.log(JSON.stringify(fs.readFileSync(-0, 'utf8')));
  process.exit(0);
}
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'nz-'));
const f = path.join(dir, 'in.txt');
fs.writeFileSync(f, 'hello\n');
const fd = fs.openSync(f, 'r');
const r = cp.spawnSync(process.execPath, [__filename, 'child'], { stdio: [fd, 'pipe', 'pipe'] });
fs.closeSync(fd);
fs.rmSync(dir, { recursive: true });
console.log('status', r.status);
console.log('stdout', r.stdout.toString());
