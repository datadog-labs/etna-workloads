process.removeAllListeners('warning');
const ffi = require('node:ffi');
const t = (f) => { try { f(); console.log('no throw'); } catch (e) { console.log(e.code, e.message); } };
t(() => ffi.getInt8('x', 0));
t(() => ffi.getInt8(1n, 'x'));
t(() => ffi.setInt8('x', 0, 1));
t(() => ffi.toBuffer(1n, 'x'));
t(() => ffi.exportBuffer(Buffer.alloc(4), "x", 4));
