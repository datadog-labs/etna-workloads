process.removeAllListeners("warning");
const ffi = require('node:ffi');
for (const View of [Uint8Array, DataView]) {
  const ab = new ArrayBuffer(1);
  const v = new View(ab);
  ab.transfer();
  try { ffi.getRawPointer(v); console.log(View.name, 'no throw'); }
  catch (e) { console.log(View.name, 'getRawPointer', e.code, e.message); }
  try { ffi.exportArrayBufferView(v, 0n, 1); console.log(View.name, 'no throw'); }
  catch (e) { console.log(View.name, 'export', e.code, e.message); }
}
