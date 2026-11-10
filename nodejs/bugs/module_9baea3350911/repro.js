const fs = require('fs'), os = require('os'), path = require('path');
const { spawnSync } = require('child_process');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'pm-'));
fs.mkdirSync(path.join(d, 'root'));
fs.mkdirSync(path.join(d, 'dep'));
fs.writeFileSync(path.join(d, 'dep/index.js'), "module.exports='dep-value';");
fs.writeFileSync(path.join(d, 'root/index.js'), "console.log(require('dep'));");
fs.writeFileSync(path.join(d, 'map.json'), JSON.stringify({ packages: {
  root: { url: './root/', dependencies: { dep: 'dep' } },
  dep: { url: './dep/', dependencies: {} },
} }));
const r = spawnSync(process.execPath, ['--no-warnings', '--experimental-package-map',
  path.join(d, 'map.json'), path.join(d, 'root/index.js')], { encoding: 'utf8', cwd: d });
console.log('status', r.status);
console.log(r.stdout.trim());
console.log(r.stderr.split('\n').find((l) => /Error/.test(l))?.replaceAll(d, '<tmp>') ?? '');
fs.rmSync(d, { recursive: true, force: true });
