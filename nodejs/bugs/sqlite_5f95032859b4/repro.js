const { DatabaseSync, constants } = require('node:sqlite');
require('v8').setFlagsFromString('--expose-gc');
const gc = require('vm').runInNewContext('gc');
const database = new DatabaseSync(':memory:');
database.exec('CREATE TABLE data(key INTEGER PRIMARY KEY)');
for (let i = 0; i < 5; i++) database.createSession(); // unreferenced
let ran = 0;
database.setAuthorizer((code, p1) => {
  if (code === constants.SQLITE_PRAGMA && p1 === 'table_xinfo') {
    ran++;
    gc(); gc();
  }
  return constants.SQLITE_OK;
});
database.exec('INSERT INTO data VALUES (1)');
console.log('authorizer ran', ran > 0);
console.log('done');
