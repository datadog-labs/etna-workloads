# Rationale

**Bug:** WebCrypto `deriveBits` for HKDF/PBKDF2 validated `length` with `validateUint32` up front, so `length === null` produced a Node `ERR_INVALID_ARG_TYPE` TypeError instead of the spec-mandated `OperationError` DOMException ("length cannot be null").

**Hunks** (the code was refactored since the fix into `validateHkdfDeriveBitsLength` / `validatePbkdf2DeriveBits`):
- `lib/internal/crypto/hkdf.js`: replaced the `length === null` -> `OperationError` check with `validateUint32(length, 'length')` (import added). Corresponds to the fix's hkdf hunks (null check + validateUint32 moved after it); null now hits the old validator.
- `lib/internal/crypto/pbkdf2.js`: same change in `validatePbkdf2DeriveBits`, for the pbkdf2 hunk. The iterations-zero part of the fix is not reverted (today's code already differs and the oracle does not cover it).

**Failing test:** `parallel/test-webcrypto-derivebits-hkdf` — the null-length case rejects with `ERR_INVALID_ARG_TYPE` rather than `OperationError`/'length cannot be null'.

**Caveat (verification):** In this environment `parallel/test-webcrypto-derivebits-hkdf` reports `not ok` by *crashing* (V8 fatal "Invoke in DisallowJavascriptExecutionScope" in `NativeCryptoKey::Create` during EC key generation, exit -5), not with the assertion failure above. A standalone run with the bug temporarily removed also crashed this way, so the crash is not caused by this change and I could not confirm the test passes on the clean build. The behavioural change was verified directly: `subtle.deriveBits({name:'HKDF',...}, key, null)` now rejects with `TypeError ERR_INVALID_ARG_TYPE` instead of `OperationError: length cannot be null`.
