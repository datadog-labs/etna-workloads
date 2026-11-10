# Rationale

**Bug:** In the broadcast consumer iterator, `return()`/`throw()` call `detach()`. A `next()` call that was already pending (`state.resolve` set) was never settled: its promise stayed pending forever after iterator cleanup.

**Hunk:** `lib/internal/streams/iter/broadcast.js`, `detach()`. The fix added `state.resolve?.({done: true, value: undefined})` before the resolve/reject were nulled. In today's code the resolve call lives in an `if (state.resolve) {...}` block ahead of `#resolvePendingDone(state)`, which nulls `state.resolve`. I removed that block. `#resolvePendingDone` then clears `resolve`/`reject` without calling them, which reproduces the pre-fix behaviour (only queued `pending` entries are settled).

**Failing test:** `parallel/test-stream-iter-broadcast-basic` (`testPendingNextSettlesAfterReturn`). `await pendingNext` never settles, so the process exits with the promise unsettled and the test reports "not ok". The failure was stable across two runs.
