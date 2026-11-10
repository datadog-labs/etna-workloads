const ah = require('async_hooks');
const ids = [];
ah.createHook({
  before(id) { ids.push('before ' + (id > 0)); },
  after(id) { ids.push('after ' + (id > 0)); },
}).enable();
process.on('uncaughtException', () => {});
setImmediate(() => { throw new Error('x'); });
setTimeout(() => {
  require('fs').writeSync(1, ids.join('\n') + '\n');
}, 20);
