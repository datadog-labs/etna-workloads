const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
fs.writeFileSync(path.join(dir, 'a.js'), 'import fs from "fs";\nlet x = ;\n');
const r = spawnSync(process.execPath, ['--check', 'a.js'], { cwd: dir, encoding: 'utf8' });
console.log('exit', r.status, 'syntaxerror', /SyntaxError: Unexpected token/.test(r.stderr));
fs.rmSync(dir, { recursive: true, force: true });
