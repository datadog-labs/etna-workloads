const { spawnSync } = require('child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--permission-audit', __filename, 'child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout + r.stderr);
  process.exit(r.status);
}
const dc = require('diagnostics_channel');
const fs = require('fs');
const os = require('os');
const file = os.tmpdir();
const denied = [];
dc.subscribe('node:permission-model:fs', (m) => denied.push(m.resource));
fs.realpathSync(file);
console.log('realpathSync reported denial for input path:', denied.includes(file));
