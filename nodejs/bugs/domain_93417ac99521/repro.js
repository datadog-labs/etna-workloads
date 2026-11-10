require('v8').setFlagsFromString('--expose-gc');
const gc = require('vm').runInNewContext('gc');
const async_hooks = require('async_hooks');
const domain = require('domain');
const EventEmitter = require('events');
const tracker = new WeakMap();
let collected = 0;
const tags = new Map();
async_hooks.createHook({
  init(id, type) { if (type.startsWith('TRACK')) tags.set(id, type); },
  destroy(id) { if (tags.has(id)) { tags.delete(id); collected++; } },
}).enable();
function track(obj, i) {
  tracker.set(obj, new async_hooks.AsyncResource('TRACK' + i));
}
let d = domain.create();
d.run(() => {
  const resource = new async_hooks.AsyncResource('TestResource');
  const emitter = new EventEmitter();
  d.remove(emitter);
  d.add(emitter);
  emitter.linkToResource = resource;
  track(resource, 0); track(d, 1); track(emitter, 2);
});
d = null;
let n = 0;
(function loop() {
  setImmediate(() => {
    gc();
    if (collected === 3) return console.log('all collected');
    if (++n >= 10) return console.log('leak: collected ' + collected + ' of 3');
    loop();
  });
})();
