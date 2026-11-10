const { spawnSync } = require('child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--permission', '--allow-fs-read=*', '--allow-fs-write=' + require('os').tmpdir(), __filename, 'child'], { encoding: 'utf8' });
  process.stdout.write(r.stdout + r.stderr);
  process.exit(r.status);
}
const fs = require('fs'), os = require('os'), path = require('path');
(async () => {
  const f = path.join(os.tmpdir(), 'repro-utimes-' + process.pid);
  const fh = await fs.promises.open(__filename, 'r');
  try {
    await fh.utimes(1, 1);
    console.log('utimes allowed');
  } catch (e) { console.log('denied', e.code); }
  await fh.close();
})();
