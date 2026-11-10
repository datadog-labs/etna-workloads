const { spawnSync } = require('child_process');
const fs = require('fs'), os = require('os'), path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'cov-'));
fs.mkdirSync(path.join(d, 'test'));
fs.writeFileSync(path.join(d, 'test', '.foo.test.js'), 'console.log(1)\n');
fs.writeFileSync(path.join(d, 'a.js'), 'module.exports = 1;\n');
fs.writeFileSync(path.join(d, 't.js'),
  "require('./a.js'); require('./test/.foo.test.js');\n");
const r = spawnSync(process.execPath, ['--test', '--experimental-test-coverage', '--test-reporter=tap', 't.js'], { cwd: d, encoding: 'utf8' });
const out = r.stdout + r.stderr;
console.log('a.js covered:', /a\.js/.test(out));
console.log('dotfile covered:', /\.foo\.test\.js/.test(out.split('start of coverage report')[1] || ''));
fs.rmSync(d, { recursive: true, force: true });
