'use strict';
const cp = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repl-ref-'));
fs.writeFileSync(path.join(dir, 'message.mjs'), "export const message = 'A message';\n");
const r = cp.spawnSync(process.execPath, ['--interactive'], {
  cwd: dir,
  input: "await import('./message.mjs');\n.exit\n",
  encoding: 'utf8',
});
const out = (r.stdout + r.stderr).replace(/^> /mg, '');
console.log(out.includes("message: 'A message'") ? 'import OK' : 'import FAILED');
fs.rmSync(dir, { recursive: true, force: true });
