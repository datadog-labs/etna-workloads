const { spawnSync } = require('child_process');
const fs = require('fs'), os = require('os'), path = require('path');
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'snap-'));
const blob = path.join(d, 'snapshot.blob');
const entry = path.join(d, 'entry.js');
fs.writeFileSync(entry, "const k=()=>console.log(JSON.stringify(Object.keys(console)));k();require('v8').startupSnapshot.setDeserializeMainFunction(k);\n");
const a = spawnSync(process.execPath, ['--snapshot-blob', blob, '--build-snapshot', entry], { cwd: d });
console.log('build', a.status);
const b = spawnSync(process.execPath, ['--snapshot-blob', blob], { cwd: d });
console.log('run', b.status);
const out = b.stdout.toString();
let same = false;
try { same = JSON.stringify(JSON.parse(out)) === JSON.stringify(JSON.parse(a.stdout.toString())); } catch {}
console.log('keys match', same);
fs.rmSync(d, { recursive: true, force: true });
