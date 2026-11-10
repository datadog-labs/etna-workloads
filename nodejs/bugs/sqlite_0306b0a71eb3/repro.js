const { DatabaseSync } = require('node:sqlite');
const db = new DatabaseSync(':memory:');
db.exec('CREATE TABLE t(a, b)');
const s = db.prepare('INSERT INTO t VALUES (:a, :b)');
try { s.run({ a: 1, b: undefined }); } catch (e) { console.log('named', e.code); }
try { s.run(2, undefined); } catch (e) { console.log('positional', e.code); }
console.log(JSON.stringify(db.prepare('SELECT * FROM t').all()));
