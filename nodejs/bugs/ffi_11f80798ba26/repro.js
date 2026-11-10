'use strict';
process.emitWarning = () => {};
const ffi = require('node:ffi');
try {
  ffi.toArrayBuffer(1n, 2 ** 50);
  console.log('no error');
} catch (e) {
  console.log('caught', e.code);
}
