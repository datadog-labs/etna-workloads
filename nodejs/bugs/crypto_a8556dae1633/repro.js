const { generateKeySync } = require('crypto');
const { Worker, isMainThread, workerData } = require('worker_threads');
if (isMainThread) {
  const w = new Worker(__filename, { workerData: generateKeySync('aes', { length: 128 }) });
  w.on('error', (e) => console.log('error'));
  w.on('exit', (c) => console.log('exit', c));
} else {
  console.log(workerData.type, workerData.symmetricKeySize);
}
