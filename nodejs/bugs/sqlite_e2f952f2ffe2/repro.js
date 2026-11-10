const { DatabaseSync, constants } = require('node:sqlite');
const db = new DatabaseSync(':memory:');
db.exec('CREATE TABLE data(key INTEGER PRIMARY KEY, value TEXT)');
const session = db.createSession();
db.exec("INSERT INTO data VALUES (1,'a'),(2,'b')");
let caught;
db.setAuthorizer(() => {
  try { session.close(); } catch (e) { caught = e; }
  return constants.SQLITE_OK;
});
try { session.changeset(); } catch (e) { console.log('changeset threw:', e.code, e.message); }
console.log('close error:', caught && caught.code, caught && caught.message);
