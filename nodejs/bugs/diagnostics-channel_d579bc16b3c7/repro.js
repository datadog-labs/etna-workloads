'use strict';
const dc = require('diagnostics_channel');
const v8 = require('v8');
const vm = require('vm');
v8.setFlagsFromString('--expose-gc');
const gc = vm.runInNewContext('gc');
function noop() {}
const refs = [];
(function() {
  for (let i = 0; i < 100; i++) {
    const name = 'chan' + i;
    dc.subscribe(name, noop);
    dc.unsubscribe(name, noop);
    refs.push(new WeakRef(dc.channel(name)));
  }
})();
setImmediate(() => {
  gc(); 
  setImmediate(() => {
    gc();
    const alive = refs.filter((r) => r.deref() !== undefined).length;
    console.log(alive === 0 ? 'all collected' : 'leaked channels');
  });
});
