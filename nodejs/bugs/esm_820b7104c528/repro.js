const { spawnSync } = require('child_process');
const fs = require('fs'), os = require('os'), path = require('path');
const { pathToFileURL } = require('url');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
fs.writeFileSync(path.join(d, 'loader.mjs'),
`import { writeSync } from 'node:fs';
export async function resolve(s, c, n) {
  if (s === 'node:fs' || s.includes('loader')) return n(s);
  writeSync(1, 'resolve hook\\n');
  return n(s);
}
`);
fs.writeFileSync(path.join(d, 'main.mjs'),
`import { runMain } from 'node:module';
try { import.meta.resolve('x.mjs') } catch {}
runMain();
try { import.meta.resolve('x.mjs') } catch {}
`);
const r = spawnSync(process.execPath, ['--no-warnings', '--experimental-import-meta-resolve',
  '--loader', pathToFileURL(path.join(d, 'loader.mjs')).href, path.join(d, 'main.mjs')], { encoding: 'utf8', cwd: d });
console.log('hook calls:', (r.stdout.match(/resolve hook/g) || []).length);
console.log('stderr:', r.stderr.replaceAll(d, '<d>'));
console.log('status', r.status);
fs.rmSync(d, { recursive: true, force: true });
