const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
fs.writeFileSync(path.join(dir, 'a.mjs'),
  "export { default as b } from './b.cjs';\nexport { default as c } from './c.mjs';\n");
fs.writeFileSync(path.join(dir, 'b.cjs'), "module.exports = require('./c.mjs');\n");
fs.writeFileSync(path.join(dir, 'c.mjs'),
  "const foo = 1;\nexport default foo;\nexport { foo as 'module.exports' };\n");
fs.writeFileSync(path.join(dir, 'main.mjs'),
  "import { b, c } from './a.mjs';\nconsole.log(b, c, b === c);\n");
const r = spawnSync(process.execPath, [path.join(dir, 'main.mjs')], { encoding: 'utf8' });
console.log('status', r.status);
console.log(r.stdout);
console.log((r.stderr.match(/^\w*Error.*$/m) || [''])[0].replace(dir, '<dir>'));
fs.rmSync(dir, { recursive: true, force: true });
