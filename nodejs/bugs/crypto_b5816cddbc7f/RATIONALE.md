# RSA-PSS one-shot sign/verify error handling (re-introduced)

**Bug:** In the one-shot sign/verify job (`SignTraits::DeriveBits`, src/crypto/crypto_sig.cc), a failure while configuring the RSA-PSS options (e.g. salt length too small for the key's restrictions) was not treated as an error. The operation continued with a context in a failed state, so `crypto.sign`/`crypto.verify` didn't reject invalid parameters.

**Change (one hunk):** the fix added `return false;` after `CheckThrow` in three places (sign init, verify init, and the RSA options application). Today's code has been refactored: the init failures use `ctx.has_value()` and the other path returns false on `ApplyRSAOptions` failure. A faithful re-expression of the old behaviour that's safe in today's code is to ignore the result of `ApplyRSAOptions` (the third fix hunk). Dropping the init-failure returns would dereference an empty optional, so I left those alone.

**Failing test:** parallel/test-crypto-sign-verify ("not ok"). Signing with `saltLength` 8/10/12 against the sha256/16 key should throw `/pss saltlen too small/` but no longer does (the first output line of the direct run is the assertion error for the missing exception).
