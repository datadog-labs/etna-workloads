const { DatabaseSync } = require('node:sqlite');
const { constants } = require('node:buffer');
const db = new DatabaseSync(':memory:');
// SQL text of exactly kMaxLength chars; the resulting error message
// ("no such column: <name>") is longer than kMaxLength.
const name = 'a'.repeat(constants.MAX_STRING_LENGTH - 7);
try {
  db.prepare('SELECT ' + name);
  console.log('no error');
} catch (e) {
  console.log('caught', e.code);
}
