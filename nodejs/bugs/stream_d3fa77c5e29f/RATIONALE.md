# Re-introduced bug: merge() abort ignored while waiting on pending sources

Bug: in `merge()` with multiple sources, if the abort signal fires while the loop is waiting
for a source to settle (all sources stuck in pending `next()`), nothing wakes the loop, so the
pending read never rejects with AbortError (it hangs until some source settles).

Hunks (lib/internal/streams/iter/consumers.js):
1. Removed the `signal.addEventListener('abort', onAbort)` block (and `onAbort` variable) –
   corresponds to the fix's first hunk adding the abort listener that resolves `waitResolve`.
2. Removed the `if (signal?.aborted) {...resolve()}` check inside the wait promise – matches the
   fix's check for an already-aborted signal when installing `waitResolve`.
3. Removed `removeEventListener` in `finally` – matches the fix's listener cleanup.
The cleanup-skip part of the fix (don't await return() for pending sources) already exists in the
release in a different form (`pendingPulls`), so it was left untouched.

Failing test: parallel/test-stream-iter-consumers-merge
(`testMergeSignalDuringPendingMultiSourceRead`) -> "not ok", the promise never settles
(AssertionError from the test run; stable across runs).
