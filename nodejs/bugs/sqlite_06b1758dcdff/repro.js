const { DatabaseSync, backup } = require('node:sqlite');
const os = require('os'), path = require('path'), fs = require('fs');
const dest = path.join(fs.mkdtempSync(path.join(os.tmpdir(), 'bk-')), 'out.db');
const db = new DatabaseSync(':memory:');
db.exec('CREATE TABLE t(a); INSERT INTO t VALUES (1);');
try {
  backup(db, dest, { rate: 0 }).then(
    () => { console.log('resolved'); process.exit(0); },
    (e) => { console.log('rejected', e.code); process.exit(0); });
  setTimeout(() => { console.log('backup with rate 0 never settled'); process.exit(1); }, 2000);
} catch (e) {
  console.log('threw', e.code, e.message);
}
