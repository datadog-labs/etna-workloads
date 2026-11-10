const fs = require('fs'), os = require('os'), path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const nm = path.join(d, 'node_modules', 'dep');
fs.mkdirSync(nm, { recursive: true });
fs.writeFileSync(path.join(nm, 'package.json'), '{"type":"module","main":"mod.js"}');
fs.writeFileSync(path.join(nm, 'mod.js'), 'export const a = 1;\n');
fs.writeFileSync(path.join(d, 'load.cjs'), "module.exports = require('dep');\n");
fs.writeFileSync(path.join(d, 'load.mjs'), "export * from 'dep';\n");
(async () => {
  try {
    const required = require(path.join(d, 'load.cjs'));
    const imported = await import(path.join(d, 'load.mjs'));
    console.log(required.a, imported.a);
    console.log(required === imported);
  } catch (e) {
    console.log('error', e.code || e.message);
  }
  fs.rmSync(d, { recursive: true, force: true });
})();
