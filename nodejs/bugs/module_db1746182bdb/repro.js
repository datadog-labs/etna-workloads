const fs = require('fs'), os = require('os'), path = require('path');
const { spawnSync } = require('child_process');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
fs.writeFileSync(path.join(d, 'a.mjs'), "import result from './b.cjs';\nexport default 'hello';\nconsole.log('import b.cjs from a.mjs', result);\n");
fs.writeFileSync(path.join(d, 'b.cjs'), "const result = require('./a.mjs');\nmodule.exports = result;\nconsole.log('require a.mjs in b.cjs', result.default);\n");
fs.writeFileSync(path.join(d, 'require-b.cjs'), "require('./b.cjs');\n");
for (const f of ['require-b.cjs', 'b.cjs']) {
  const r = spawnSync(process.execPath, ['--experimental-require-module', path.join(d, f)], { encoding: 'utf8' });
  const out = (r.stdout + r.stderr).split('\n').filter((l) => /Cannot|^import|^require/.test(l))
    .map((l) => l.replaceAll(d, '<d>'));
  console.log(f, 'status', r.status, out);
}
fs.rmSync(d, { recursive: true, force: true });
