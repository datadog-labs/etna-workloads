const { DatabaseSync } = require('node:sqlite');
const db = new DatabaseSync(':memory:');
for (const v of [0, -1, 1.5, NaN, Infinity, 2 ** 40, '10', null, {}]) {
  try {
    db.createTagStore(v);
    console.log(String(typeof v === 'object' ? JSON.stringify(v) : v), 'accepted');
  } catch (e) {
    console.log(String(typeof v === 'object' ? JSON.stringify(v) : v), e.code);
  }
}
