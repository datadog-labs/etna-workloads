const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'wr-'));
const app = path.join(dir, 'app.js');
fs.writeFileSync(app, "console.log('APP RAN');\n");
const c = spawn(process.execPath, ['--watch_path=' + dir, app], { cwd: dir, detached: true, stdio: ['ignore', 'pipe', 'pipe'] });
let out = '', ran = false;
const finish = () => {
  clearTimeout(t);
  try { process.kill(-c.pid, 'SIGKILL'); } catch {}
  console.log('app ran:', ran);
  fs.rmSync(dir, { recursive: true, force: true });
  process.exit(0);
};
const t = setTimeout(finish, 6000);
c.stdout.on('data', (d) => { out += d; if (out.includes('APP RAN')) { ran = true; finish(); } });
