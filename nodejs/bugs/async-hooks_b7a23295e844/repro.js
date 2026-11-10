const async_hooks = require('async_hooks');
let initial;
let afters = 0;
const promise = new Promise((resolve) => {
  setTimeout(() => {
    initial = async_hooks.executionAsyncId();
    async_hooks.createHook({ after() { afters++; } }).enable();
    resolve();
  }, 0);
});
promise.then(() => {
  const id = async_hooks.executionAsyncId();
  console.log('id differs from initial:', id !== initial);
  console.log('id > 0:', id > 0);
  setImmediate(() => console.log('afters:', afters));
});
