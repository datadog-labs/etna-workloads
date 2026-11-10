// Run a child with --enable-source-maps; assert.ok(false) in a file with no source map.
const { spawnSync } = require('child_process');
const fs = require('fs'), os = require('os'), path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const f = path.join(dir, 't.cjs');
fs.writeFileSync(f, "const assert = require('node:assert');\ntry { assert.ok(false); } catch (e) { console.log(e.name, e.code, JSON.stringify(e.message)); }\n");
const r = spawnSync(process.execPath, ['--enable-source-maps', f], { encoding: 'utf8' });
console.log((r.stdout + r.stderr).split(dir).join('<dir>'), r.status);
fs.rmSync(dir, { recursive: true });
