const { spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
fs.writeFileSync(path.join(dir, 's.js'), 'console.log(JSON.stringify(process.argv.slice(2)));');
for (const args of [['s.js', '--config-file=missing.json'], ['s.js', '--config-file'], ['s.js', 'a', '--experimental-default-config-file']]) {
  const r = spawnSync(process.execPath, args, { cwd: dir, encoding: 'utf8' });
  console.log(r.status, r.stdout.trim(), r.stderr.split('\n')[0].replace(/\/\S*/g, '<p>'));
}
fs.rmSync(dir, { recursive: true });
