# Re-introduced bug: crypto update(buf, enc) validates encoding for buffers

**Bug:** Cipher/Decipher/Hash/Hmac `update()` validated the input encoding even when the data was a Buffer/TypedArray. With `'hex'` and an odd-length buffer, `validateEncoding` threw `ERR_INVALID_ARG_VALUE`, although the encoding should be ignored for buffers.

**Hunks (the release code has moved on; same logic re-expressed):**
1. `lib/internal/crypto/cipher.js` (`update`, shared by Cipheriv/Decipheriv): replaced `if (typeof data === 'string') validateEncoding(...) else if (!isArrayBufferView) throw` with the pre-fix form: type check `typeof data !== 'string' && !isArrayBufferView(data)` followed by an unconditional `validateEncoding(data, inputEncoding)`. Corresponds to the cipher.js hunk of the fix.
2. `lib/internal/crypto/hash.js` (`Hash.prototype.update`, also used by Hmac): same reversal with `encoding`. Corresponds to the hash.js hunk.

**Failing test:** `parallel/test-crypto-update-encoding` — `TypeError [ERR_INVALID_ARG_VALUE]: The argument 'encoding' is invalid for data of length 15. Received 'hex'` at `Cipheriv.update`. Fails stably across repeated runs.
