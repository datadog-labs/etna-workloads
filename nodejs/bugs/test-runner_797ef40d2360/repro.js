'use strict';
const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');

const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'dualpkg-'));
const pkg = path.join(dir, 'node_modules', 'dual-pkg');
fs.mkdirSync(pkg, { recursive: true });
fs.writeFileSync(path.join(pkg, 'package.json'), JSON.stringify({
  name: 'dual-pkg',
  exports: { '.': { import: './index.mjs', require: './index.cjs' } },
}));
fs.writeFileSync(path.join(pkg, 'index.mjs'), "export const flavor = 'esm';\n");
fs.writeFileSync(path.join(pkg, 'index.cjs'), "exports.flavor = 'cjs';\n");
fs.writeFileSync(path.join(dir, 'main.js'), `
const { test } = require('node:test');
test('x', async (t) => {
  t.mock.module('dual-pkg', { namedExports: { flavor: 'mocked' } });
  console.log('require:', require('dual-pkg').flavor);
  console.log('import:', (await import('dual-pkg')).flavor);
});
`);
const r = spawnSync(process.execPath,
  ['--experimental-test-module-mocks', '--test-reporter=tap', 'main.js'],
  { cwd: dir, encoding: 'utf8' });
const lines = (r.stdout + r.stderr).split('\n').filter((l) => /^(require|import):/.test(l));
console.log(lines.join('\n'));
fs.rmSync(dir, { recursive: true, force: true });
