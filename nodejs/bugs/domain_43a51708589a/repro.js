const domain = require('domain');
const d = domain.create();
d.on('error', (er) => {
  console.log('handler: active is own domain =', process.domain === d, domain.active === d);
});
d.run(() => {
  setImmediate(() => { throw new Error('boom'); });
});
const e = domain.create();
e.on('error', () => console.log('emitter handler: in own domain =', process.domain === e));
e.run(() => { process.nextTick(() => e.emit('error', new Error('x'))); });
