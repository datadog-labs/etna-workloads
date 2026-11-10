const { DatabaseSync } = require('node:sqlite');
const db = new DatabaseSync(':memory:');
db.exec('CREATE TABLE t(a INTEGER PRIMARY KEY, b TEXT)');
const session = db.createSession();
let closeResult = 'not attempted';
let armed = false;
db.setAuthorizer(() => {
  if (armed) {
    armed = false;
    try { session.close(); closeResult = 'closed'; } catch (e) { closeResult = 'threw: ' + e.code; }
  }
  return 0; // SQLITE_OK
});
armed = true;
db.exec("INSERT INTO t VALUES (1, 'x')");
console.log('close from authorizer:', closeResult);
db.setAuthorizer(null);
try { session.close(); console.log('late close ok'); } catch (e) { console.log('late close threw', e.code); }
