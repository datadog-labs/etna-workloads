const { DatabaseSync } = require('node:sqlite');
function t(name, fn) {
  try { fn(); console.log(name, 'ok'); } catch (e) { console.log(name, e.code); }
}
const db = new DatabaseSync(':memory:', { allowExtension: true });
db.close();
t('enableLoadExtension', () => db.enableLoadExtension(true));
t('setAuthorizer', () => db.setAuthorizer(() => 0));
