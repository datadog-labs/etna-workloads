const { BlockList } = require('net');
const a = new BlockList();
a.addAddress('::ffff:192.0.2.128', 'ipv6');
a.addRange('::ffff:192.0.2.1', '::ffff:192.0.2.10', 'ipv6');
a.addSubnet('::ffff:192.0.2.0', 120, 'ipv6');
const json = a.toJSON();
console.log(json);
const b = new BlockList();
try { b.fromJSON(json); } catch (e) { console.log('err', e.code); }
console.log(b.toJSON());
console.log(b.check('192.0.2.128'), b.check('::ffff:192.0.2.5', 'ipv6'));
