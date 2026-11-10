# Re-introduced bug: AbortSignal 'abort' event is not trusted

**Bug.** The `abort` event dispatched by `AbortController.abort()` should have `isTrusted === true`. Before the fix, all internally created events had `isTrusted: false`.

**Hunk.** The fix has hunks in abort_controller.js, event_target.js and primordials.js.
- The event_target.js and primordials.js hunks (the `kTrustEvent` symbol, the `SafeWeakSet`-backed `isTrusted` getter) are still in the release, so they stay untouched. In the release they have moved, so the plain reversal doesn't apply.
- In `lib/internal/abort_controller.js`, `runAbort` now calls `new Event('abort')` without the `[kTrustEvent]: true` option. This reverses the fix's `abortSignal` hunk, which today lives in `runAbort`. The unused `kTrustEvent` import is also removed, as in the fix's import hunk. The event is therefore never added to the trusted set, so `isTrusted` is false.

**Failing test.** `parallel/test-abortcontroller` fails ("not ok") on the "abort events are trusted" case, because `assert.ok(event.isTrusted)` fails. The assertion is thrown inside the onabort handler, so it surfaces as an uncaughtException ("generated asynchronous activity after the test ended ... AssertionError: assert.ok(event.isTrusted)"), and the process exits with code 1. The failure was stable across two runs.
