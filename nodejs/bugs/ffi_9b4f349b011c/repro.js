'use strict';
process.emitWarning = () => {};
const ffi = require('node:ffi');
const { lib, functions } = ffi.dlopen('libc.so.6', {
  memset: { arguments: ['pointer', 'i32', 'u64'], return: 'pointer' },
});
const s = 'abcdef';
// Native code clobbers the temporary UTF-8 copy of the string.
const p1 = functions.memset(s, 0x58, 3);
console.log(JSON.stringify(ffi.toString(p1)));
// Same JS string, no-op call: should see a fresh copy of the bytes.
const p2 = functions.memset(s, 0, 0);
console.log(JSON.stringify(ffi.toString(p2)));
lib.close();
