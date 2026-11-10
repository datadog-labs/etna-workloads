const { spawnSync } = require('child_process');
const fs = require('fs'), os = require('os'), path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'snap-'));
fs.writeFileSync(path.join(d, 'b.js'), `
console.log('build limit', Error.stackTraceLimit);
console.log('has stack', typeof new Error('x').stack);
`);
let r = spawnSync(process.execPath, ['--stack-trace-limit=50', '--snapshot-blob', path.join(d, 's.blob'), '--build-snapshot', path.join(d, 'b.js')], { cwd: d, encoding: 'utf8' });
console.log(r.status, r.stdout, r.stderr.replace(/\n+$/, ''));
fs.writeFileSync(path.join(d, 'c.js'), `
Error.stackTraceLimit = 7;
`);
r = spawnSync(process.execPath, ['--snapshot-blob', path.join(d, 's2.blob'), '--build-snapshot', path.join(d, 'c.js')], { cwd: d, encoding: 'utf8' });
console.log(r.status, r.stdout, r.stderr.replace(/\n+$/, ''));
r = spawnSync(process.execPath, ['--stack-trace-limit=20', '--snapshot-blob', path.join(d, 's2.blob'), '-p', 'Error.stackTraceLimit'], { cwd: d, encoding: 'utf8' });
console.log(r.status, r.stdout, r.stderr.replace(/\n+$/, ''));
fs.rmSync(d, { recursive: true });
