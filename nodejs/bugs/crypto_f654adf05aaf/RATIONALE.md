# Re-introduced bug: webcrypto deriveBits for non-byte lengths

**Bug.** For ECDH/X25519/X448 `subtle.deriveBits(alg, key, length)` with a `length` that is not a multiple of 8, the result was truncated *down* (floor) to whole bytes instead of being the ceiled number of bytes (with trailing bits zeroed). E.g. length 383 returned 47 bytes' worth minus one byte (46) instead of 48.

**Change** (`lib/internal/crypto/diffiehellman.js`, `ecdhDeriveBits`). The fix replaced `MathFloor(length / 8)` with `MathCeil(length / 8)` in the old `asyncDeriveBitsECDH`. In today's code that logic is `numBitsToBytes(length)` (a ceil) plus `truncateToBitLength` (masks the trailing bits). I replaced them with `MathFloor(length / 8)` and `ArrayBufferPrototypeSlice(bits, 0, sliceLength)`, restoring the pre-fix floor/slice behaviour. I also swapped the imports accordingly (added `MathFloor`, `ArrayBufferPrototypeSlice`; removed the now-unused `numBitsToBytes`, `truncateToBitLength`). Tests were not touched.

**Failing tests** (stable over 2 runs): `parallel/test-webcrypto-derivebits-cfrg` and `parallel/test-webcrypto-derivebits-ecdh`, e.g. AssertionError: Expected values to be strictly deep-equal: actual Buffer(46), expected Buffer(47).
