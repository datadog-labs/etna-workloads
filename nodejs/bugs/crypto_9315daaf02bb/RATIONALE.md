# Re-introduced bug: key handle extraction returns the error instead of throwing

**Bug.** The validation helper built an `ERR_INVALID_ARG_TYPE` for a key object where none is allowed, but used `return new ...` instead of `throw new ...`. The caller ignored the return value, so the invalid input was silently accepted. Passing an existing key object to `createPrivateKey()` did not throw.

**Hunk.** `lib/internal/crypto/keys.js`, `validateAsymmetricKeyType()`, in the `ctx === kCreatePrivate` branch: `throw new ERR_INVALID_ARG_TYPE(...)` became `return new ERR_INVALID_ARG_TYPE(...)`.
This matches the fix's single hunk (`return new` -> `throw new` in `getKeyObjectHandle`). That function no longer exists in this form: the `!allowKeyObject` check now lives in `validateAsymmetricKeyType`, and the key-object handle is read in `prepareAsymmetricKey`. `prepareAsymmetricKey` ignores the returned error, so the old defect comes back.

**Failing test.** `parallel/test-crypto-key-objects` reports `not ok`. The failing case is the one that asserts `createPrivateKey(privateKey)` throws `ERR_INVALID_ARG_TYPE` ("Missing expected exception"). I ran it three times and it failed each time. I did not save the full assertion text.
