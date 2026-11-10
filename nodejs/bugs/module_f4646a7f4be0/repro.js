const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
fs.writeFileSync(path.join(dir, 'dep.cjs'), 'module.exports = 1;\n');
fs.writeFileSync(path.join(dir, 'main.mjs'),
`import { registerHooks } from 'node:module';
let n = 0;
registerHooks({ resolve(s, c, next) { if (s.endsWith('dep.cjs')) n++; return next(s, c); } });
await import('./dep.cjs');
console.log('resolve calls for dep.cjs:', n);
`);
const r = spawnSync(process.execPath, [path.join(dir, 'main.mjs')], { encoding: 'utf8' });
process.stdout.write(r.stdout + r.stderr);
fs.rmSync(dir, { recursive: true, force: true });
