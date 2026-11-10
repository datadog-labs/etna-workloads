const { spawnSync } = require('child_process');
if (process.argv[2] === 'child') {
  const net = require('net');
  const c = net.connect({ path: 'nonexistent-repro.sock' });
  c.on('error', (e) => console.log('error code:', e.code));
  c.on('connect', () => console.log('connected'));
} else {
  const r = spawnSync(process.execPath,
    ['--permission', '--allow-fs-read=*', __filename, 'child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout);
  console.log('child exit', r.status);
}
