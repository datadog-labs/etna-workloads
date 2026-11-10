process.removeAllListeners('warning');
const ffi = require('node:ffi');
const lib = new ffi.DynamicLibrary('libc.so.6');
const memset = lib.getFunction('memset', {
  arguments: ['buffer', 'i32', 'u64'],
  return: 'void',
});
const bytes = Buffer.alloc(4);
const ptr = ffi.getRawPointer(bytes);
try {
  memset(ptr, 7, 4n);
  console.log('bigint ok', [...bytes]);
} catch (e) {
  console.log('error:', e.name, e.code);
}
lib.close();
