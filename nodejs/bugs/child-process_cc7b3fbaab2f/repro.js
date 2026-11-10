const { spawn } = require('child_process');
const a = spawn('echo', ['hello-a']);
const c1 = spawn('cat', [], { stdio: [a.stdout, 'pipe', 'inherit'] });
let out = '';
c1.stdout.on('data', (d) => out += d);
c1.on('close', () => {
  console.log('c1', JSON.stringify(out), 'destroyed=' + a.stdout.destroyed);
  try {
    const c2 = spawn('cat', [], { stdio: [a.stdout, 'pipe', 'inherit'] });
    c2.on('error', (e) => console.log('err', e.code));
    c2.on('close', (code) => console.log('c2 code', code));
    c2.stdout.resume();
  } catch (e) { console.log('throw', e.code || e.message); }
});
setTimeout(() => process.exit(0), 5000).unref();
