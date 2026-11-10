const { Worker, isMainThread } = require('worker_threads');
if (isMainThread) {
  const w = new Worker(__filename);
  w.on('message', (m) => console.log('result:', m));
  w.on('error', (e) => console.log('error:', e.message));
  w.on('exit', (c) => console.log('exit', c));
} else {
  const { parentPort } = require('worker_threads');
  process.once('uncaughtException', () => {});
  const res = process._fatalException(new Error('x'));
  parentPort.postMessage(typeof res + ' ' + res);
}
