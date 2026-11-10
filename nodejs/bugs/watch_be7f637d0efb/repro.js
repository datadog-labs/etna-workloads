const { spawn } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
fs.writeFileSync(path.join(dir, 'child.js'), "console.log('CHILD NODE_OPTIONS=' + JSON.stringify(process.env.NODE_OPTIONS));\n");
const p = spawn(process.execPath, ['--watch', 'child.js'], {
  cwd: dir,
  env: { ...process.env, NODE_OPTIONS: '--watch-preserve-output --no-warnings' },
});
let out = '';
let t; const done = () => { clearTimeout(t); p.kill('SIGKILL'); fs.rmSync(dir, { recursive: true, force: true }); };
p.stdout.on('data', (d) => {
  out += d;
  const m = /CHILD NODE_OPTIONS=.*/.exec(out);
  if (m && out.includes('\n', m.index)) { console.log(m[0]); done(); }
});
p.stderr.resume();
t = setTimeout(() => { console.log('timeout'); done(); }, 15000);
