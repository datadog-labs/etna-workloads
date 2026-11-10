const { fork } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const file = path.join(dir, 'main.mjs');
fs.writeFileSync(file, "console.log('hello, wor");
const child = fork(file, [], {
  env: { ...process.env, WATCH_REPORT_DEPENDENCIES: '1' },
  silent: true,
});
let got = false;
child.on('message', (m) => {
  if (m['watch:import']?.some((u) => u.endsWith('/main.mjs'))) got = true;
});
child.on('exit', (code) => {
  console.log('child exit code:', code);
  console.log('dependency reported:', got);
  fs.rmSync(dir, { recursive: true, force: true });
});
