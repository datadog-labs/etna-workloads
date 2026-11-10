const dns = require('dns');
const p = dns.promises;
function show(label, fn) {
  try { const r = fn(); if (r && r.then) { r.then(() => console.log(label, 'resolved'), e => console.log(label, 'rejected', e.code)); } else console.log(label, 'no throw'); }
  catch (e) { console.log(label, 'threw', e.code); }
}
show('resolve4', () => dns.resolve4('a\0b', () => {}));
show('resolve', () => dns.resolve('a\0b', () => {}));
show('setLocalAddress', () => new dns.Resolver().setLocalAddress('1.2.3.4\0x'));
show('setLocalAddress6', () => new dns.Resolver().setLocalAddress('1.2.3.4', '::1\0x'));
