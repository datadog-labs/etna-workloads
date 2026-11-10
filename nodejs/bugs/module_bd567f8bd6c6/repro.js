const fs = require('fs'), path = require('path'), os = require('os');
const { spawnSync } = require('child_process');
const { pathToFileURL } = require('url');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'pm-'));
const root = path.join(d, 'root');
fs.mkdirSync(root);
fs.writeFileSync(path.join(root, 'package.json'), JSON.stringify({
  name: 'root', imports: { '#x': './x.js' },
}));
fs.writeFileSync(path.join(root, 'x.js'), 'module.exports = "x-ok";');
fs.writeFileSync(path.join(root, 'main.js'), 'try { console.log(require("#x")); } catch (e) { console.log(e.code); }');
const map = path.join(d, 'map.json');
fs.writeFileSync(map, JSON.stringify({ packages: { root: { url: pathToFileURL(root).href, dependencies: {} } } }));
const r = spawnSync(process.execPath, ['--no-warnings', '--experimental-package-map', map, path.join(root, 'main.js')], { encoding: 'utf8', cwd: root });
console.log(r.stdout.trim(), r.status);
fs.rmSync(d, { recursive: true, force: true });
