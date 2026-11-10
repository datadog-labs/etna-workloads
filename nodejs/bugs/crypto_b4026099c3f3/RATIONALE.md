# Re-introduced bug: setAuthTag() after update() (upstream b4026099c3f3)

**Bug.** In GCM mode `decipher.setAuthTag()` is documented to work any time before `final()`. Before the fix, the tag was only stashed and handed to OpenSSL on the first `update()` (or in CCM `setAAD`). If `setAuthTag()` was called after `update()`, the tag never reached OpenSSL and `final()` failed with "Unsupported state or unable to authenticate data".

**Changes** (src/crypto/crypto_cipher.{cc,h}). The current code passes the tag to OpenSSL immediately inside `SetAuthTag`, so it was restructured back to the deferred model.

1. `SetAuthTag` now only copies the tag into `auth_tag_` and sets `auth_tag_pending_`, instead of calling `setAeadTag`. This is the pre-fix behaviour, where `SetAuthTag` only recorded `auth_tag_len_`/`auth_tag_`.
2. New `CipherBase::MaybePassAuthTagToOpenSSL()` (plus header declaration and `auth_tag_pending_` member). It corresponds to the fix's new helper.
3. `SetAAD` (CCM, decipher) calls it before specifying the plaintext length. This matches the fix's `SetAAD` hunk.
4. `Update` calls it for authenticated deciphers before the first update. This matches the fix's `Update` hunk.
5. The fix's `Final` hunk (passing the tag in `final()`) is deliberately absent. That is the defect: a tag set after the last `update()` is never passed on.

**Failing test.** `parallel/test-crypto-authenticated` fails in `testAllOrders` (line 682, `decipher.final()`) with `Error: Unsupported state or unable to authenticate data`. It failed in both runs after the build.
