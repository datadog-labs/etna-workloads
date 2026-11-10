# Re-introduced bug: crypto.verify with a private KeyObject (callback form) aborts

**Bug.** The async `crypto.verify(algorithm, data, key, signature, callback)` path runs through
`SignTraits::DeriveBits`. When verifying, it asserted that the key was a *public* key. Since
`crypto.verify` legitimately accepts private keys (the public part is derived), passing a private
key/PEM/DER made the process abort on the assertion instead of invoking the callback.

**Change (src/crypto/crypto_sig.cc, one hunk).** In `SignTraits::DeriveBits`, in the
`Mode::Verify` case, added `CHECK_EQ(params.key.GetKeyType(), kKeyTypePublic);`. This corresponds
to the fix's hunk changing `CHECK_EQ(..., kKeyTypePublic)` to `CHECK_NE(..., kKeyTypeSecret)`.
The release no longer had any check there (code was refactored), so the old strict check is
re-added in the equivalent location, restoring the old behaviour.

**Failing test.** `parallel/test-crypto-async-sign-verify` crashes (exit -6):
`Assertion failed: (params.key.GetKeyType()) == (kKeyTypePublic)` at crypto_sig.cc:829.
Failure was stable across repeated runs.
