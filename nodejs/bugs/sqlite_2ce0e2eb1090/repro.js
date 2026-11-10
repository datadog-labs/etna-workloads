const { DatabaseSync, constants } = require('node:sqlite');
const db = new DatabaseSync(':memory:');
db.exec('CREATE TABLE data(key INTEGER PRIMARY KEY, value TEXT)');
const s = db.createSession({ table: 'data' });
s.close();
try { s[Symbol.dispose](); console.log('dispose closed: ok'); }
catch (e) { console.log('dispose closed:', e.message); }

const s2 = db.createSession({ table: 'data' });
db.exec("INSERT INTO data VALUES (1,'a')");
db.setAuthorizer(() => {
  try { s2[Symbol.dispose](); console.log('dispose in use: no throw'); }
  catch (e) { console.log('dispose in use:', e.message); }
  return constants.SQLITE_OK;
});
try { console.log(s2.changeset().length > 0); } catch (e) { console.log('changeset:', e.message); }
db.setAuthorizer(null);
console.log('changeset after:', s2.changeset().length > 0);
