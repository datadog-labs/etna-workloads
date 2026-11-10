'use strict';
const { spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
if (process.argv[2] === 'build') {
  const crypto = require('crypto');
  const v8 = require('v8');
  crypto.randomUUID();
  crypto.randomInt(100);
  v8.startupSnapshot.setDeserializeMainFunction(() => {
    const c = require('crypto');
    console.log(JSON.stringify([c.randomUUID(), c.randomInt(2 ** 40)]));
  });
} else {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'rs-'));
  const blob = path.join(dir, 's.blob');
  const r = spawnSync(process.execPath, ['--snapshot-blob', blob, '--build-snapshot', __filename, 'build'], { encoding: 'utf8' });
  if (r.status !== 0) { console.log('build failed', r.stderr); process.exit(2); }
  const run = () => spawnSync(process.execPath, ['--snapshot-blob', blob, 'x'], { encoding: 'utf8' }).stdout;
  const a = run(), b = run();
  fs.rmSync(dir, { recursive: true, force: true });
  console.log(a === b ? 'SAME random values after snapshot restore' : 'different values (ok)');
}
