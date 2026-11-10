const { DatabaseSync } = require('node:sqlite');
try {
  new DatabaseSync({ href: 'not a url' });
  console.log('no throw');
} catch (e) {
  console.log(e.code, e.message);
}
