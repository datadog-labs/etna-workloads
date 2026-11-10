const fs = require('fs'), os = require('os'), path = require('path');
const { spawnSync } = require('child_process');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
fs.mkdirSync(path.join(d, 'node_modules'), { recursive: true });
fs.mkdirSync(path.join(d, 'sub'));
fs.writeFileSync(path.join(d, 'sub/x.js'), 'module.exports=1');
fs.writeFileSync(path.join(d, 'package.json'), JSON.stringify({ imports: { '#a/*': './sub/*' } }));
fs.writeFileSync(path.join(d, 'm.mjs'), "import '#a//x.js';\n");
const r = spawnSync(process.execPath, ['--pending-deprecation', 'm.mjs'], { cwd: d, encoding: 'utf8' });
const out = (r.stdout + r.stderr).replace(/\(node:\d+\)/g, '(node)').split(d).join('<D>').split('\n')
  .filter((l) => l.includes('DEP0166') || l.includes('deprecated')).join('\n');
console.log(out, r.status);
fs.rmSync(d, { recursive: true, force: true });
