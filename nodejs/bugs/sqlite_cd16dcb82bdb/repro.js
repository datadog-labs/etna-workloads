const { DatabaseSync } = require('node:sqlite');
const db = new DatabaseSync(':memory:');
db.exec('CREATE TABLE t(a INTEGER); INSERT INTO t VALUES (1),(2),(3);');
db.createModule('m', {
  columns: [
    { name: 'v', type: 'INTEGER' },
    { name: 'a', type: 'INTEGER', hidden: true },
  ],
  rows(a) {
    if (a === null || a === undefined) return [];
    return [[a * 10]];
  },
});
db.exec('CREATE VIRTUAL TABLE mm USING m');
const q = 'SELECT DISTINCT * FROM m(t.a) JOIN t ON t.a = m.a ORDER BY t.a';
try {
  console.log(JSON.stringify(db.prepare(q).all()));
} catch (e) {
  console.log('error:', e.message);
}
