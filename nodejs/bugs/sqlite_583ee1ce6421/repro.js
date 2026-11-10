const { DatabaseSync } = require('node:sqlite');
const db = new DatabaseSync(':memory:');
const cleaned = [];
db.createModule('rc', {
  columns: [{ name: 'input', type: 'INTEGER', hidden: true }],
  *rows(input) {
    try { yield [input]; } finally { cleaned.push(input); }
  },
});
db.exec('CREATE TABLE t(a); INSERT INTO t VALUES (1),(2),(3)');
const rows = db.prepare('SELECT a FROM t WHERE EXISTS(SELECT 1 FROM rc(t.a))').all();
console.log(rows.length, JSON.stringify(cleaned));
