const { DatabaseSync } = require('node:sqlite');
const os = require('os'), fs = require('fs'), path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'ls-'));
const file = path.join(dir, 'ls.db');
const db = new DatabaseSync(file);
db.exec(`CREATE TABLE nodejs_webstorage(key BLOB NOT NULL, value BLOB NOT NULL, PRIMARY KEY(key));
CREATE TABLE nodejs_webstorage_state(max_size INTEGER NOT NULL DEFAULT 10485760, total_size INTEGER NOT NULL, schema_version INTEGER NOT NULL DEFAULT 0, single_row_ INTEGER NOT NULL DEFAULT 1, PRIMARY KEY(single_row_));
INSERT INTO nodejs_webstorage_state(total_size, schema_version) VALUES(0, 'abc');`);
db.close();
if (process.argv[2] === 'child') {
  try { localStorage.getItem('a'); console.log('no throw'); }
  catch (e) { console.log('threw', e.code); }
} else {
  const r = require('child_process').spawnSync(process.execPath,
    ['--no-warnings', '--localstorage-file=' + file, __filename, 'child'], { encoding: 'utf8' });
  console.log(r.stdout.trim(), r.status === null ? 'signal' : (r.status === 0 ? 'ok' : 'abnormal exit'));
}
fs.rmSync(dir, { recursive: true, force: true });
