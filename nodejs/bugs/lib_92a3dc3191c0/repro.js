const { spawnSync } = require('child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--no-warnings', '--permission', '--allow-addons', '--allow-fs-read=*', __filename, 'child'], { encoding: 'utf8' });
  console.log(r.stdout + r.stderr);
  console.log('status', r.status);
} else {
  process.permission.drop('addon');
  console.log('has addon:', process.permission.has('addon'));
  try { process.dlopen({ exports: {} }, '/nonexistent/binding.node'); console.log('loaded'); }
  catch (e) { console.log('code:', e.code); }
}
