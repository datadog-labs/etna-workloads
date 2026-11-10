# Re-introduced bug: CipherBase::Update int32 overflow

**Bug:** `CipherBase::Update` computes `int buf_len = len + block_size` with no overflow check. For inputs of ~2^31-1 bytes, the sum overflows int32 (negative/undefined), so the update proceeds with a bogus buffer length instead of failing with an error. The result is a crash or memory error rather than a thrown exception.

**Hunk (src/crypto/crypto_cipher.cc):** corresponds to the single hunk of the fix. The fixed code extracts `block_size`, `CHECK_GT(block_size, 0)`, and returns `kErrorState` if `len + block_size > INT_MAX`. In today's code (`ctx_.getBlockSize()`), I replaced those four lines with the pre-fix `int buf_len = len + ctx_.getBlockSize();`.

**Failing test:** `parallel/test-crypto-cipheriv-decipheriv` reports `not ok`. The new case calls `update(Buffer.allocUnsafeSlow(2**31-1))` and expects a throw, and it no longer throws or crashes cleanly.
