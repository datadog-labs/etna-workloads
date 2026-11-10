const { spawn } = require('child_process');
const c = spawn('nonexistent-cmd-xyz', { timeout: 5000 });
c.on('error', (e) => console.log('error', e.code));
c.on('exit', () => console.log('exit'));
c.on('close', () => console.log('close'));
const t = setTimeout(() => {}, 0); clearTimeout(t);
process.on('exit', () => {
  const handles = process.getActiveResourcesInfo().filter((x) => x === 'Timeout');
  console.log('active timeouts at exit:', handles.length);
});
// Force check shortly after the error has settled
setTimeout(() => {
  const n = process.getActiveResourcesInfo().filter((x) => x === 'Timeout').length;
  console.log('pending timers after settle:', n - 1);
  process.exit(0);
}, 200);
