const dc = require('diagnostics_channel');
const ch = dc.channel('repro-ch');
try { ch.subscribe('not a function'); console.log('no throw'); } catch (e) { console.log('threw', e.code); }
console.log('hasSubscribers', ch.hasSubscribers);
