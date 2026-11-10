# Bug
webcrypto `deriveKey` took the derived key length straight from `derivedKeyAlgorithm.length` instead of computing the algorithm default (HMAC hash size, null for HKDF/PBKDF2). With no explicit `length` (e.g. HMAC with only a hash, or PBKDF2/HKDF), `length` was undefined and the derive-bits step got a wrong/missing length.

# Change
`lib/internal/crypto/webcrypto.js`, `deriveKeyImpl`: replaced `const length = getKeyLength(normalizedDerivedKeyAlgorithmLength);` with `const { length } = normalizedDerivedKeyAlgorithmLength;`. This reverses the fix's single hunk (`const { length } = derivedKeyAlgorithm;` -> `getKeyLength(...)`), re-expressed for today's code. The `getKeyLength` helper is left in place since it is still used by `getPublicKey`/wrapKey-related code (line ~1840).

# Failing test
parallel/test-webcrypto-derivekey fails: the "default key lengths" case calls ECDH deriveKey with undefined length and the process aborts with `Assertion failed: args[offset + 3]->IsInt32()` (exit code -6) instead of deriving 160/256/384/512/528 bits.
