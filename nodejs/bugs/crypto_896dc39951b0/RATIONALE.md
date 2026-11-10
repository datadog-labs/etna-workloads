# Re-introduced bug: webcrypto deriveBits resolves with a Buffer instead of an ArrayBuffer

Upstream 896dc39951b0 fixed `subtle.deriveBits()` for PBKDF2 (and scrypt), which resolved with the
callback `Buffer` rather than the `ArrayBuffer` required by the WebCrypto spec (`resolve(result)` vs
`resolve(result.buffer)`). The fix's tests add `assert(bits instanceof ArrayBuffer)` for all derive algorithms.
Today's code uses native `*Job(kCryptoJobWebCrypto)` objects (no callback-based `new Promise`),
and scrypt WebCrypto was removed, so the old hunks cannot be reversed literally. The defect is re-expressed by
making the promises resolve with a `Buffer` view instead of an `ArrayBuffer`.

## Hunks (all in lib/internal/crypto)
- `pbkdf2.js` <-> fix hunk in pbkdf2.js: `pbkdf2DeriveBits` wraps the job promise with
  `jobPromiseThen(..., (bits) => Buffer.from(bits))` (imports `jobPromiseThen`), so it resolves with a Buffer (old `resolve(result)`).
- `hkdf.js` and `diffiehellman.js` (`ecdhDeriveBits`, all return paths): same defect, applied where the current
  tests assert `instanceof ArrayBuffer` (corresponding to the test hunks for hkdf/ecdh/node-dh); needed because
  PBKDF2/derivebits tests only compare hex and so don't detect the PBKDF2 change alone. (scrypt: no WebCrypto deriveBits left in the release.)
  `hkdf.js` also gets a `Buffer` import.

## Failing tests
`parallel/test-webcrypto-derivebits`, `-ecdh`, `-hkdf` fail (stable over 2 runs):
`AssertionError [ERR_ASSERTION]: The expression evaluated to a falsy value: assert(bits instanceof ArrayBuffer)`.
