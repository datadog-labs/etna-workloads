const { GCProfiler } = require('v8');
const { spawnSync } = require('child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--expose-gc', '--minor-ms', __filename, 'child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout + r.stderr);
  process.exit(r.status);
}
const p = new GCProfiler();
p.start();
global.gc({ type: 'minor', execution: 'sync' });
const prof = p.stop();
console.log(prof.statistics.map((s) => s.gcType));
