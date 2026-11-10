'use strict';
const { Database } = require('node:sqlite');
function defensive(db) {
  db.exec('PRAGMA journal_mode=OFF');
  return db.prepare('PRAGMA journal_mode').get().journal_mode === 'memory';
}
const db = new Database(':memory:', { defensive: false });
db.enableDefensive(true);
db.close();
db.open();
console.log('defensive after reopen:', defensive(db));
