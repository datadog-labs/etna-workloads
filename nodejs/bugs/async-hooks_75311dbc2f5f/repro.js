const ah = require('async_hooks');
const ev = [];
ah.createHook({
  before(id) { ev.push('before'); },
  after(id) { ev.push('after'); },
}).enable();
try {
  new ah.AsyncResource('foo').runInAsyncScope(() => { throw new Error('bar'); });
} catch {}
require('fs').writeSync(1, ev.join(',') + ' ' + ah.executionAsyncId() + '\n');
