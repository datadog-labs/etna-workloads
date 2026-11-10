# Re-introduced bug: Hash digest not cached (nodejs/node#28245)

**Bug.** When data is piped into a Hash stream, `Hash._flush` calls the native `digest()`, which finalizes the EVP context. A later user call to `hash.digest()` finalizes again. For SHA3 this is unsupported (segfault in old OpenSSL; here an `ERR_OSSL_EVP_FINAL_ERROR` "final error" is thrown).

**Change** (src/crypto/crypto_hash.cc, `Hash::HashDigest`). The fix cached the result of `EVP_DigestFinal_ex` (the `md_value_`/`md_len_` members in node_crypto.cc/.h) and only finalized when nothing was cached (`if (hash->md_len_ == 0)`). In today's code the cache is the `digest_` ByteSource, and the guard is `if (!hash->digest_ && len > 0)`. I changed the guard to `if (len > 0)`, so the context is finalized on every call. This matches the pre-fix behaviour of calling `EVP_DigestFinal_ex` unconditionally. The header hunk (cache members and destructor) has no counterpart: the member `digest_` is still used, now as a per-call buffer, so no header change is needed.

**Failing test.** `parallel/test-crypto-hash-stream-pipe` fails. `h.digest('hex')` called inside the 'data' handler throws `Error: error:030000BC:digital envelope routines::final error` (code ERR_OSSL_EVP_FINAL_ERROR). It failed on both runs.
