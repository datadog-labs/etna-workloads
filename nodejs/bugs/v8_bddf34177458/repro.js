const s = require('v8').startupSnapshot;
for (const f of ['addSerializeCallback', 'addDeserializeCallback', 'setDeserializeMainFunction']) {
  try { s[f](() => {}); console.log(f, 'no error'); }
  catch (e) { console.log(f, e.name, e.code, e.message); }
}
