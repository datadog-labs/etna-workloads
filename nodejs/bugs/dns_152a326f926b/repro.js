const dns = require('dns');
for (const bad of [123, null, undefined, {}]) {
  try { dns.lookupService(bad, 80, () => {}); console.log('no throw'); }
  catch (e) { console.log('cb', e.code); }
  try { dns.promises.lookupService(bad, 80).catch((e) => console.log('p-rej', e.code)); }
  catch (e) { console.log('p', e.code); }
}
