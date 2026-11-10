# Re-introduced bug: crypto aborts instead of propagating exceptions thrown while decorating errors

**Bug.** When OpenSSL errors are turned into JS exceptions, properties (`library`, `opensslErrorStack`) are set on the error object. If a setter on `Object.prototype` throws, the pending JS exception should propagate. Before the fix, the `Set` results were `.Check()`ed, so the process aborted (fatal V8 check) instead.

**Changes (src/crypto/crypto_util.cc)** — today's code already returns Maybe/MaybeLocal everywhere, so only the hunks that dropped error checking are re-expressed:
1. `CryptoErrorStore::ToException`: the `opensslErrorStack` Set now uses `.Check()` instead of returning an empty MaybeLocal on failure. Corresponds to the fix's `CryptoErrorVector::ToException` hunk (replacing `.Check()` with `IsNothing()` handling).
2. `error::Decorate`: the `library` Set uses `.Check()` instead of returning `Nothing`. Corresponds to the fix's `Decorate` hunks (returning `Nothing` rather than silently/abortingly ignoring failures).

**Failing test.** `parallel/test-crypto-sign-verify` → `not ok` (process aborts on the new "exceptional conditions" block with a V8 fatal Check failure instead of throwing 'bye, bye, library' / 'bye, bye, error stack'). Stable over repeated runs.
