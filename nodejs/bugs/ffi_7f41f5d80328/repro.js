process.removeAllListeners('warning');
const ffi = require('node:ffi');
const lib = new ffi.DynamicLibrary('libc.so.6');
try {
  lib.getFunction('abs', { return: 'i32', arguments: ['void'] });
  console.log('no error');
} catch (e) { console.log(e.code); }
try {
  lib.getFunctions({ abs: { return: 'i32', arguments: ['void'] } });
  console.log('no error');
} catch (e) { console.log(e.code); }
lib.close();
