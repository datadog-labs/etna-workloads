const { isUtf8, isAscii } = require('buffer');
const ab = new ArrayBuffer(8);
const u8 = new Uint8Array(ab);
structuredClone(ab, { transfer: [ab] });
for (const [n, f] of [['isUtf8', isUtf8], ['isAscii', isAscii]]) {
  for (const [k, v] of [['ab', ab], ['u8', u8]]) {
    try { console.log(n, k, f(v)); } catch (e) { console.log(n, k, 'throws', e.code); }
  }
}
