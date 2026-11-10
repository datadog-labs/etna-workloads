const { spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
fs.writeFileSync(path.join(d, 'esm.mjs'), 'export const v = "esm";\n');
fs.writeFileSync(path.join(d, 'main.cjs'), 'console.log("value:", require("./esm.mjs").v);\n');
fs.writeFileSync(path.join(d, 'hooks.mjs'),
  'export async function load(url, ctx, next) { if (url.endsWith("esm.mjs")) console.log("hook load esm.mjs"); return next(url, ctx); }\n');
fs.writeFileSync(path.join(d, 'reg.mjs'),
  'import { register } from "node:module";\nregister("./hooks.mjs", import.meta.url);\n');
const r = spawnSync(process.execPath, ['--import', path.join(d, 'reg.mjs'), path.join(d, 'main.cjs')], { encoding: 'utf8', cwd: d });
const clean = (s) => s.split(d).join('<d>').split('file://<d>').join('<d>');
console.log('status', r.status);
console.log(clean(r.stdout));
console.log(clean(r.stderr).split('\n').filter((l) => /^\w*Error|ERR_/.test(l)).join('\n'));
fs.rmSync(d, { recursive: true, force: true });
