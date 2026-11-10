const { Database } = require('node:sqlite');
const db = new Database(':memory:');
try {
  db.prepare('SELECT 1', { get returnArrays() { db.close(); return false; } });
  console.log('no error');
} catch (e) { console.log(e.code, e.message); }
