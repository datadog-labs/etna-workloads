# Re-introduced bug: AbortSignal.any() with timeout signals

**Bug:** `AbortSignal.timeout()` signals are only weakly referenced (the timer holds a WeakRef). When they are passed to `AbortSignal.any()` and no one holds them, they can be garbage collected before the timer fires. The composite signal then never aborts. The fix keeps timeout sources and the composite alive through `gcPersistentSignals`.

## Changes (lib/internal/abort_controller.js)
1. In `any()`, removed the `hasTimeoutSignals` tracking and the `gcPersistentSignals.add(signal)` for timeout sources. This matches fix hunk 1 (loop part).
2. Removed the post-loop block (today it sets `resultSignal[kTimeout] = true` when timeouts exist). It corresponds to the fix's `gcPersistentSignals.add(resultSignal)` hunk. Without it, the composite is not persisted via `kNewListener`.
3. Removed the cleanup at the end of `abortSignal()` (`gcPersistentSignals.delete(signal)` and the source-signal deletes). This matches the fix's last hunk. The whitespace-only hunks are not reproduced.

## Result
`parallel/test-abort-controller-any-timeout` fails ("not ok") on both runs, because the abort never fires and the test's 10s fallback timer wins.
