'use strict';
// Suppress the "(node:<pid>) ExperimentalWarning" output, since the PID
// varies between runs and would otherwise break determinism.
process.emitWarning = () => {};
const ffi = require('node:ffi');
const lib = new ffi.DynamicLibrary(null);
lib.getFunction('abs', { arguments: ['i32'], return: 'i32' });
try {
  lib.getFunction('abs', {
    arguments: ['i32'],
    get return() { lib.close(); return 'i32'; },
  });
  console.log('no error');
} catch (e) {
  console.log(e.code);
}
