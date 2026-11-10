# Re-introduced bug
With OpenSSL >= 3.4, SHAKE128/SHAKE256 report a digest size of 0, so `createHash('shake128').digest()` without `outputLength` returns an empty buffer instead of the historical 16/32-byte defaults (and `crypto.hash('shake128', ...)` yields an empty/inconsistent digest).

# Change
- `src/crypto/crypto_hash.cc`, `Hash::HashInit`: removed the block that, for XOF digests with no explicit length and `md_len_ == 0`, sets `md_len_` to 16 (SHAKE128) or 32 (SHAKE256). Corresponds to the fix's crypto_hash.cc hunk; this restores the pre-fix behaviour.
- The fix's lib/ hunks (DEP0198 pending-deprecation warning, `hash()` routing shake through `Hash`) are not reverted. In today's tree, the one-shot path already gets its default via the C++ `Hash` code. Removing the C++ default alone reproduces the defect, so no lib/ change was needed.

# Failing tests
- parallel/test-crypto-hash: `actual: '' expected: '7f9c2ba4e88f827d616045507605853e'`
- parallel/test-crypto-oneshot-hash: `actual: Buffer(16) ... expected: Buffer(0) []` (one-shot and streaming digests disagree)
- test-crypto-default-shake-lengths still passes.
