# Re-introduced bug: stream.finished on Duplex (nodejs/node#33130)

**Bug:** `finished()` / `eos()` treats a Duplex as already finished when only one side
(writable finished OR readable ended) has completed, and calls back immediately
instead of waiting for both sides.

**Change (lib/internal/streams/end-of-stream.js, one hunk, two lines removed):**
Corresponds to the fix's `closed` computation hunk, which changed
`wState.finished || rState.endEmitted` into
`(!writable || wState.finished) && (!readable || rState.endEmitted)`.
In today's code that logic lives in the two immediate-result branches guarded by
`!readable &&` and `!writable &&`. I removed those two guards, so a finished writable
side alone (or ended readable side alone) triggers the immediate callback, as before the fix.

**Failing test:** parallel/test-stream-finished, e.g.
`AssertionError [ERR_ASSERTION]: function should not have been called at test-stream-finished.js:565`
(`p.end(); finished(p, common.mustNotCall())` on a PassThrough). Failure was stable over 2 runs.
