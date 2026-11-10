const { DatabaseSync } = require('node:sqlite');
const db = new DatabaseSync(':memory:');
db.exec('CREATE TABLE t(a)');
let result = 'no error';
db.setAuthorizer((action) => {
  try { db.prepare('SELECT 1'); result = 'prepare allowed'; }
  catch (e) { result = 'prepare rejected: ' + e.code; }
  return 0;
});
try { db.prepare('SELECT * FROM t'); } catch (e) { console.log('outer', e.code); }
console.log(result);
