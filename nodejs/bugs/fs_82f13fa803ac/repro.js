const { spawnSync } = require('child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--expose-internals', '--no-warnings', __filename, 'child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout); process.stdout.write(r.stderr);
  process.exit(r.status);
}
const { getDirents } = require('internal/fs/utils');
const { internalBinding } = require('internal/test/binding');
const { UV_DIRENT_UNKNOWN } = internalBinding('constants').fs;
const fs = require('fs'), os = require('os'), path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
fs.writeFileSync(path.join(dir, 'foo'), '');
getDirents(dir, [[Buffer.from('foo')], [UV_DIRENT_UNKNOWN]], (err, names) => {
  console.log('string+Buffer:', err ? err.code : 'ok ' + names.length);
  getDirents(Buffer.from(dir), [[Buffer.from('foo')], [UV_DIRENT_UNKNOWN]], (err, names) => {
    console.log('Buffer+Buffer:', err ? err.code : 'ok ' + names.length);
    fs.rmSync(dir, { recursive: true });
  });
});
