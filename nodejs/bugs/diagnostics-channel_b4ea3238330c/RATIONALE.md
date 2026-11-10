# Re-introduced bug: tracePromise consistency with non-Promises

## Bug
`TracingChannel.prototype.tracePromise` coerced the callback's return value into a native
Promise (`PromiseResolve`) and chained on it. Non-thenable return values were therefore turned
into promises (return value changed), asyncStart/asyncEnd were published for them, no warning was
emitted, and thenables were replaced by native promises instead of being returned as-is.

## Changes (lib/diagnostics_channel.js only)
- No-subscribers fast path: removed the `typeof result?.then !== 'function'` check and
  `emitNonThenableWarning` call; plain `return ReflectApply(...)`. Corresponds to the fix's first
  `tracePromise` hunk (the warning on non-thenables).
- Subscribed path: replaced the non-thenable early return, native-promise check and
  non-native-thenable branch with `PromisePrototypeThen(PromiseResolve(result), onResolve, onRejectWithRethrow)`.
  Corresponds to the fix's hunk replacing `PromiseResolve`/`PromisePrototypeThen` conversion with
  the thenable check/warning/`result.then(...)`. (Rejection rethrow via `onRejectWithRethrow` already
  matches the old `PromiseReject(err)` semantics.)
- Removed now-unused `emitNonThenableWarning`, `isPromise`, `PromisePrototype`; added `PromiseResolve`
  (mirrors the fix's import changes).

## Failing tests (stable across 2 runs)
- parallel/test-diagnostics-channel-tracing-channel-promise-non-thenable: asyncStart/asyncEnd
  are called (mustNotCall) and the return value is a Promise, no warning.
- parallel/test-diagnostics-channel-tracing-channel-promise-thenable: result is a native
  Promise, not the ResolvedThenable (`assert(result instanceof ResolvedThenable)` fails).
