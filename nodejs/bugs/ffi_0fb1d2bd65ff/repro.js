'use strict';
// After the FFI wrapper is hot (optimized), out-of-range u32 arguments must
// still be rejected rather than silently truncated by the Fast API trampoline.
const ffi = require('node:ffi');
// dup2(1, fd) is a harmless no-op when fd == 1.
const { dup2 } = ffi.dlopen(null, {
  dup2: { arguments: ['u32', 'u32'], return: 'i32' },
}).functions;
function call(v) { return dup2(1, v); }
function hot(n) { let s = 0; for (let i = 0; i < n; i++) s += call(1); return s; }
for (let k = 0; k < 300; k++) hot(2000);
for (const v of [4294967297, 8589934593, -4294967295]) {
  try { console.log(v, 'returned', call(v)); } catch (e) { console.log(v, 'threw', e.code); }
}
