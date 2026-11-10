const m = require('module');
for (const v of [123, {}, null]) {
  try { m.enableCompileCache(v); console.log('no throw'); }
  catch (e) { console.log(e.code); }
}
