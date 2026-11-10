const { spawnSync } = require('child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, [__filename, 'child'], { encoding: 'utf8' });
  console.log(r.stdout.trim());
  process.exit(r.status);
}
const inspector = require('inspector');
const http = require('http');
inspector.open(0, '127.0.0.1');
const port = Number(new URL(inspector.url()).port);
const req = http.get({ host: '127.0.0.1', port, path: '/json/version', headers: { Host: '0.0.0.1:' + port } }, (res) => {
  console.log('status', res.statusCode);
  res.resume();
  res.on('end', () => { inspector.close(); process.exit(0); });
});
req.on('error', (e) => { console.log('error', e.code); inspector.close(); process.exit(0); });
