const { DatabaseSync, constants } = require('node:sqlite');
const db = new DatabaseSync(':memory:');
db.exec('CREATE TABLE t (x INTEGER)');
db.exec('INSERT INTO t VALUES (1), (2), (3)');
const stmt = db.prepare('SELECT x FROM t');
const iter = stmt.iterate();
iter.next();
let outcome = 'authorizer did not run';
db.setAuthorizer((code) => {
  if (code === constants.SQLITE_DROP_TABLE) {
    try { stmt.close(); outcome = 'close did not throw'; }
    catch (e) { outcome = `${e.code}: ${e.message}`; }
  }
  return constants.SQLITE_OK;
});
try { db.exec('DROP TABLE t'); console.log('drop succeeded'); }
catch (e) { console.log('drop failed:', e.message); }
console.log(outcome);
