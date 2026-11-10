const { Worker } = require('node:worker_threads');
const w = new Worker('', { eval: true });
const l = () => {};
w.on('message', l);
w.on('messageerror', l);
w.on('exit', () => {
  console.log('message', w.listenerCount('message'));
  console.log('messageerror', w.listenerCount('messageerror'));
});
