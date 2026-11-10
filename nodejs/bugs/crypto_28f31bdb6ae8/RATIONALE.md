# Rationale

**Bug:** webcrypto AES-GCM decrypt called `ArrayBufferPrototypeSlice` on the input data, which throws a TypeError when data is a TypedArray/view (e.g. `new Uint8Array(encrypted)`) instead of an ArrayBuffer.

**Change (lib/internal/crypto/aes.js, single hunk):** In the original fix, the decrypt branch chose `TypedArrayPrototypeSlice` for views and `ArrayBufferPrototypeSlice` otherwise. In today's code the tag split happens in C++ (src/crypto/crypto_aes.cc), so the JS no longer slices. I re-expressed the old behaviour in `asyncAesGcmCipher`: on decrypt, `data = ArrayBufferPrototypeSlice(data, 0)` (unconditional ArrayBuffer slice, a semantic no-op copy for ArrayBuffers), plus the needed imports (`ArrayBufferPrototypeSlice`, `kWebCryptoCipherDecrypt`). This restores the failure for views.

**Failing test:** parallel/test-webcrypto-encrypt-decrypt-aes — `TypeError: Method ArrayBuffer.prototype.slice called on incompatible receiver [object Uint8Array]` (stable over 2 runs).
