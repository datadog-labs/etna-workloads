process.emitWarning = () => {};
const ffi = require('node:ffi');
const buf = new ArrayBuffer(4);
Object.defineProperty(buf, Symbol.toStringTag, { value: 'Custom' });
const target = new ArrayBuffer(8);
try {
  ffi.exportArrayBuffer(buf, 0n, 4);
  console.log('ok');
} catch (e) { console.log(e.code); }
try {
  ffi.exportArrayBuffer({ [Symbol.toStringTag]: 'ArrayBuffer', byteLength: 1 }, 0n, 4);
} catch (e) { console.log(e.code); }
