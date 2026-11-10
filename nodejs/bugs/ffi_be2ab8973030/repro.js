'use strict';
process.removeAllListeners('warning');
const ffi = require('node:ffi');
const ab = new ArrayBuffer(8);
const ta = new Uint8Array(ab);
ab.transfer();
for (const [name, v] of [['ab', ab], ['ta', ta]]) {
  try {
    console.log(name, typeof ffi.getRawPointer(v));
  } catch (e) {
    console.log(name, e.code, e.message);
  }
}
try {
  ffi.exportArrayBuffer(ab, 0n, 0);
  console.log('export ok');
} catch (e) {
  console.log('export', e.code, e.message);
}
