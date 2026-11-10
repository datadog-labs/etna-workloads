const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'snap-'));
fs.writeFileSync(path.join(dir, 'main.js'), '');
const cases = {
  empty: Buffer.alloc(0),
  foreign: Buffer.from('this is definitely not a node snapshot blob, just text'),
};
for (const [name, data] of Object.entries(cases)) {
  const f = path.join(dir, name + '.blob');
  fs.writeFileSync(f, data);
  const r = spawnSync(process.execPath, ['--snapshot-blob', f, path.join(dir, 'main.js')], { encoding: 'utf8' });
  const out = (r.stdout + r.stderr).split('\n').filter((l) => /snapshot/i.test(l) && !l.includes(dir)).join('|');
  console.log(name, 'signal=' + r.signal, 'status=' + r.status, out);
}
fs.rmSync(dir, { recursive: true, force: true });
