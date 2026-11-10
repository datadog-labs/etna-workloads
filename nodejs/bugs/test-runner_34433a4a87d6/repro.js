const fs = require('fs'), os = require('os'), path = require('path');
const { spawnSync } = require('child_process');
if (process.argv[2] === 'driver') {
  if (process.env.REPRO_NESTED) { console.log('DRIVER RERUN AS TEST'); process.exit(0); }
  process.env.REPRO_NESTED = '1';
  const { run } = require('node:test');
  const names = [];
  const ac = new AbortController();
  const s = run({ cwd: process.argv[3], watch: true, isolation: 'none', signal: ac.signal });
  s.on('test:pass', (d) => names.push(d.name));
  s.on('data', ({ type }) => { if (type === 'test:watch:drained') ac.abort(); });
  (async () => { for await (const _ of s); console.log(JSON.stringify(names.sort())); })();
  return;
}
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const cwd = path.join(root, 'cwd'); fs.mkdirSync(cwd);
fs.writeFileSync(path.join(cwd, 'test.js'), "require('node:test')('test ran from cwd', () => {});\n");
const drv = path.join(root, 'driver.js');
fs.writeFileSync(drv, fs.readFileSync(__filename));
const r = spawnSync(process.execPath, [drv, 'driver', cwd], { cwd: root, encoding: 'utf8', timeout: 20000 });
console.log('status', r.status);
console.log(r.stdout.split('\n').filter((l) => l.startsWith('[') || l.startsWith('DRIVER')).join('\n'));
fs.rmSync(root, { recursive: true, force: true });
