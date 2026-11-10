const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
fs.writeFileSync(path.join(d, 'app.js'), "console.log('Hello world');\n");
fs.writeFileSync(path.join(d, 'sync.mjs'),
  "import { registerHooks } from 'node:module';\nregisterHooks({ load(u, c, n) { return n(u, c); } });\n");
fs.writeFileSync(path.join(d, 'loader.mjs'),
  "export async function load(u, c, n) { return n(u, c); }\n");
fs.writeFileSync(path.join(d, 'async.mjs'),
  "import { register } from 'node:module';\nregister(new URL('loader.mjs', import.meta.url));\n");
const r = spawnSync(process.execPath, [
  '--import', path.join(d, 'sync.mjs'), '--import', path.join(d, 'async.mjs'), path.join(d, 'app.js'),
], { encoding: 'utf8' });
console.log('status', r.status);
console.log(r.stdout.trim());
console.log(/ERR_INVALID_RETURN_PROPERTY_VALUE/.test(r.stderr) ? 'ERR_INVALID_RETURN_PROPERTY_VALUE' : 'no error');
fs.rmSync(d, { recursive: true, force: true });
