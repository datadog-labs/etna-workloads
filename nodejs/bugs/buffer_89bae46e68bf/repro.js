'use strict';
// Decoding unaligned UTF-16LE with an odd byte count should ignore the
// trailing incomplete code unit.
for (const size of [514, 516]) {
  const buffer = Buffer.alloc(size, 0x61);
  const s = buffer.toString('utf16le', 1);
  const expected = '慡'.repeat((size - 1) >>> 1);
  console.log(size, s.length, s === expected);
}
