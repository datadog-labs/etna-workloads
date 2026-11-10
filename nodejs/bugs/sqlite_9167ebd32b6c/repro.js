const { DatabaseSync } = require('node:sqlite');
const db = new DatabaseSync(':memory:');
db.exec('CREATE TABLE t(a BLOB)');
const ins = db.prepare('INSERT INTO t VALUES (?)');
const ab = new Uint8Array([1, 2, 3]).buffer;
try { ins.run(ab); } catch (e) { console.log('ArrayBuffer error:', e.code); }
try { ins.run(new SharedArrayBuffer(2)); } catch (e) { console.log('SAB error:', e.code); }
db.function('f', () => new Uint8Array([9]).buffer);
try { console.log(db.prepare('SELECT f() AS x').get()); } catch (e) { console.log('fn error:', e.code); }
console.log(db.prepare('SELECT a FROM t').all());
