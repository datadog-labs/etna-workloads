const { DatabaseSync } = require('node:sqlite');
const db = new DatabaseSync(':memory:');
db.exec('CREATE TABLE t(a INTEGER PRIMARY KEY, b TEXT)');
const s = db.createSession();
db.exec("INSERT INTO t VALUES(1,'x')");
db.close();
db.open();
try { console.log(s.changeset().length); } catch (e) { console.log(e.code); }
try { s.close(); console.log('closed'); } catch (e) { console.log(e.code); }
