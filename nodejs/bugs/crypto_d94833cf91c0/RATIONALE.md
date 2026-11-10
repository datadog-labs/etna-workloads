# Rationale

**Bug:** `prepareAsymmetricKey` only took the JWK path when `data` looked like a JWK (`data.kty !== undefined`) and `format === 'jwk'`. With `{ key: 'foo' | null | undefined | true | Boolean, format: 'jwk' }` the input fell through to the PEM/DER path and failed with a different, wrong error (originally a crash, #44471) instead of `ERR_INVALID_ARG_TYPE` for `key.key`.

**Hunk:** `lib/internal/crypto/keys.js`, `prepareAsymmetricKeyOptions`. This corresponds to the fix's `else if (format === 'jwk') { validateObject(...) }` hunk. I restored the old `isJwk(data) && format === 'jwk'` condition inline (`data != null && data.kty !== undefined`) and dropped the `validateObject(data, `${name}.key`)` call. The fix's other hunks only moved `isJwk` between modules, and that helper no longer exists in today's code, so no hunk was needed for them.

**Failing tests:** `parallel/test-crypto-key-objects` fails with `message: 'Invalid JWK format'`, where the test expects `/The "key\.key" property must be of type object/`. `parallel/test-crypto-sign-verify` also fails. Both failed on two runs.
