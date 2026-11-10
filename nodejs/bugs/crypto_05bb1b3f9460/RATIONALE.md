# Re-introduced bug: scrypt `maxmem` dropped in ScryptConfig move constructor

**Bug.** After the scrypt refactor, `ScryptConfig`'s move constructor did not copy `maxmem`. The job
moves the config after `AdditionalConfig` parses it, so `maxmem` in the moved-to object is
uninitialized. `EVP_PBE_scrypt` then gets a garbage memory limit. Valid scrypt calls can fail with
"memory limit exceeded", and the "toobig" cases can wrongly succeed. The failure is nondeterministic.

**Hunks.**
- `src/crypto/crypto_scrypt.cc`: removed `maxmem(other.maxmem),` from the move constructor. This is the
  reverse of the fix's `ScryptConfig::ScryptConfig(ScryptConfig&&)` hunk.
- The other fix hunks were not re-applied:
  - webcrypto `scryptDeriveBits` rename: no such code exists in the release.
  - `ReleaseToBackingStore` CHECK: already differs from the pre-fix code.
  - `OPENSSL_NO_SCRYPT` init guard: restructured in the release.
  - The comment typo fix: cosmetic.

**Test results.** `parallel/test-crypto-scrypt` fails intermittently because `maxmem` is uninitialized.
Across 9 runs it was "not ok" 3 times, so the failure is not stable. I did not capture the failure
message. `parallel/test-webcrypto-derivebits` and `parallel/test-webcrypto-derivekey` pass.
`sequential/test-async-wrap-getasyncid` fails in my sandbox with `listen EPERM` on a unix socket. That
is an environment issue, unrelated to this change.
