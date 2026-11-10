'use strict';
// Reproduces: src: fix out-of-bounds write when transcoding odd-length ucs2
//
// When transcoding from 'ucs2'/'utf16le', the number of *whole* UTF-16 code
// units is length_in_chars = floor(byteLength / 2). A correct implementation
// copies exactly length_in_chars * 2 bytes into the conversion buffer and
// ignores a trailing odd byte. The reintroduced bug instead copies the full
// (odd) source byte length into a buffer sized for length_in_chars code
// units, writing one byte past the end of a heap allocation.
//
// That one-byte heap overflow corrupts allocator bookkeeping for an adjacent
// chunk. It doesn't change the converted text itself, so we can't detect it
// by comparing output content; instead we drive many odd-length heap-sized
// allocations through the vulnerable path interleaved with normal
// allocations, so a corrupted heap chunk header reliably trips glibc's
// consistency checks (SIGABRT) on the buggy binary, while the clean binary
// completes and exits normally.

const buffer = require('buffer');

for (let iter = 0; iter < 2000; iter++) {
  for (const len of [2049, 4099]) {
    const src = Buffer.alloc(len, 0x61);
    buffer.transcode(src, 'utf16le', 'latin1');
    buffer.transcode(src, 'utf16le', 'ascii');
  }
  // Allocate/free unrelated heap objects so a corrupted chunk header is
  // exercised (and its corruption detected) by glibc's malloc/free.
  const junk = [];
  for (let j = 0; j < 8; j++) junk.push(Buffer.alloc(64 + j));
  junk.length = 0;
}

console.log('done');
