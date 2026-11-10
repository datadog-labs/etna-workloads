# Bug
`writer.fail(reason)` with a falsy reason (0, null, false, '') left reads pending/unrejected, because the read paths decided whether the queue was errored by truthiness of the stored error instead of by writer state.

# Changes (lib/internal/streams/iter/push.js)
1. `PushQueue.read()` (~line 463): `if (writerState === 'errored')` -> `&& this.#writerError`. Corresponds to the fix hunk `-if (this.#writerState === 'errored' && this.#error)` in read; a falsy error now skips the throw, so the read falls through and returns a never-settling promise.
2. `#resolvePendingReads` (~line 564): same re-added `&& this.#writerError`. Corresponds to the fix's hunk in the pending-reads loop; pending reads are not rejected for falsy reasons (loop breaks).
The kNoFailReason sentinel hunks have no equivalent in today's code (fail() has no `??` default here), so nothing to revert there.

# Result
test/parallel/test-stream-iter-push-writer: "not ok" (stable over 2 runs); the falsy-reason future-read and pending-read cases no longer reject (the reads hang / mustCall unmet).
