'use strict';
const { spawn } = require('child_process');
if (process.argv[2] !== 'worker') {
  // Run worker in its own process group so a stray kill(0) can't hit us.
  const w = spawn(process.execPath, [__filename, 'worker'],
                  { detached: true, stdio: ['ignore', 'pipe', 'inherit'] });
  let out = '';
  w.stdout.on('data', (d) => out += d);
  w.on('close', (code, sig) => {
    process.stdout.write(out);
    console.log('worker exit code=%s signal=%s', code, sig);
  });
} else {
  const c = spawn('/nonexistent-cmd-for-repro', []);
  c.on('error', () => {});
  const r = c.kill();
  console.log('kill returned', r);
  setTimeout(() => console.log('worker survived'), 200);
}
