process.removeAllListeners('warning');
process.emitWarning = () => {};
const ffi = require('node:ffi');
const names = ['getInt8','getUint8','getInt16','getUint16','getInt32','getUint32','getInt64','getUint64','getFloat32','getFloat64',
  'setInt8','setUint8','setFloat64','toBuffer','toArrayBuffer'];
for (const n of names) {
  try { console.log(n, 'returned', ffi[n]()); }
  catch (e) { console.log(n, 'threw', e.code); }
}
