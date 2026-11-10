const dc = require('diagnostics_channel');
const ch = dc.channel('repro');
function onMessage() {
  console.log('got message');
  ch.unsubscribe(onMessage);
}
ch.subscribe(onMessage);
try {
  ch.publish({});
  console.log('publish ok');
} catch (e) {
  console.log('sync throw');
}
process.on('uncaughtException', (e) => {
  console.log('uncaught:', e instanceof TypeError ? 'TypeError' : 'other');
});
