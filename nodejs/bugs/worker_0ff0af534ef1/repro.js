const { MessageChannel } = require('worker_threads');
const { port1, port2 } = new MessageChannel();
function t(name, fn) {
  try { fn(); console.log(name, 'no throw'); }
  catch (e) { console.log(name, e.name, e.message); }
}
const ab = new ArrayBuffer(8);
t('ab', () => port1.postMessage(ab, [ab, ab]));
const { port1: a, port2: b } = new MessageChannel();
t('port', () => port1.postMessage(a, [a, a]));
port1.close(); port2.close(); a.close(); b.close();
