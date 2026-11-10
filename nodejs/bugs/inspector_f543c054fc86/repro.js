const { Session } = require('inspector');
const { Worker, isMainThread } = require('worker_threads');
if (isMainThread) {
  const w = new Worker(__filename);
  w.on('exit', (c) => console.log('worker exit', c));
  w.on('error', (e) => console.log('error', e.message));
} else {
  const s = new Session();
  s.connectToMainThread();
  s.disconnect();
  console.log('disconnected');
}
