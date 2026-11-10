# Re-introduced bug
`subtle.exportKey()` on a non-extractable key rejected with a DOMException named `InvalidAccessException` (not a valid WebCrypto error name) instead of `InvalidAccessError`.

## Change
`lib/internal/crypto/webcrypto.js` (exportKey, line ~838): `'InvalidAccessError'` -> `'InvalidAccessException'`. This is the reverse of the single implementation hunk of the fix, at its new line number (the old hunk did not apply because the code had moved).

## Failing tests
All five oracle tests fail (cfrg, ec, ml-dsa, ml-kem, rsa), stable over two runs:
`actual: InvalidAccessException: key is not extractable` vs expected `{ message: /key is not extractable/, name: 'InvalidAccessError' }`.
