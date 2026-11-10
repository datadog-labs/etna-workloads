const { Buffer } = require('buffer');
for (const align of [1, 2, 4, 8, 16]) {
  const buf = Buffer.allocUnsafe(100, align);
  const rest = buf.buffer.byteLength - buf.byteOffset;
  let ok;
  try {
    new BigUint64Array(buf.buffer, buf.byteOffset);
    ok = true;
  } catch (e) { ok = e.name; }
  console.log(align, buf.byteOffset % align, rest % 8, ok);
}
