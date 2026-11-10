if (process.argv[2] !== 'child') {
  const r = require('child_process').spawnSync(process.execPath,
    ['--expose-internals', __filename, 'child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout + r.stderr);
  process.exit(r.status);
}
const { getCIDR } = require('internal/util');
console.log(getCIDR('10.0.0.1', '255.10.0.0', 'IPv4'));
console.log(getCIDR('10.0.0.1', '255.192.0.0', 'IPv4'));
