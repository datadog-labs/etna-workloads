const { run } = require('node:test');
for (const env of ['str', 1, true]) {
  try { run({ files: [], env }); console.log('no throw'); }
  catch (e) { console.log(e.code, e.message); }
}
