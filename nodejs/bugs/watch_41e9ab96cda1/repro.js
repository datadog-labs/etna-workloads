const { spawnSync } = require('child_process');
const fs = require('fs'), os = require('os'), path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
fs.writeFileSync(path.join(dir, 'app.js'), 'console.log("title=" + process.title);\nprocess.exit(0);\n');
const r = spawnSync(process.execPath, ['--watch', 'app.js'], {
  cwd: dir, encoding: 'utf8', timeout: 15000,
  env: { ...process.env, NODE_OPTIONS: '--title="a \\"q\\" b"' },
});
console.log('status', r.status);
console.log((r.stdout + r.stderr).split('\n').filter((l) => /title=|unterminated/.test(l)).join('\n'));
fs.rmSync(dir, { recursive: true, force: true });
