const vm = require('vm');
const { subtle } = globalThis.crypto;
const buf = vm.runInNewContext('new Uint8Array([1,2,3]).buffer');
subtle.digest('SHA-256', buf).then(
  (r) => console.log('ok', Buffer.from(r).toString('hex')),
  (e) => { console.log('error', e.name); process.exitCode = 1; });
