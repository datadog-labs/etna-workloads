const net = require('net');
function t(f) {
  try { f(); console.log('no throw'); } catch (e) { console.log(e.code); }
}
t(() => net.connect());
t(() => net.connect({}));
t(() => new net.Socket().connect());
t(() => new net.Socket().connect({}));
process.exit(0);
