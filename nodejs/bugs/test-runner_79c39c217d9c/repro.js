const { spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'dotrepro-'));
fs.writeFileSync(path.join(dir, 'lib.js'), 'exports.a = () => 1;\nexports.b = () => {\n  return 2;\n};\n');
fs.writeFileSync(path.join(dir, 'a.test.js'), "require('node:test').test('x', () => { require('./lib.js').a(); });\n");
const r = spawnSync(process.execPath, ['--test', '--test-reporter=dot', '--experimental-test-coverage',
  '--test-coverage-lines=100', 'a.test.js'],
  { cwd: dir, encoding: 'utf8', env: { ...process.env, NO_COLOR: '1', FORCE_COLOR: '0', NODE_DISABLE_COLORS: '1' } });
const out = (r.stdout + r.stderr).replaceAll(dir, '<dir>');
console.log('exit=' + r.status);
console.log(/coverage/i.test(out) ? 'mentions coverage' : 'no coverage info');
console.log(out.split('\n').filter((l) => /threshold|coverage/i.test(l)).join('\n'));
fs.rmSync(dir, { recursive: true, force: true });
