# Re-introduced bug: pipe() ignores writableNeedDrain

**Bug:** `Readable.prototype.pipe` did not check whether the destination already had a full buffer (`dest.writableNeedDrain`). It resumed the source and wrote to the destination right away, even though the destination was waiting for 'drain'.

**Change (lib/internal/streams/readable.js):** this corresponds to the fix's readable.js hunk. In today's code the fix's `src.pause()` call is the local `pause()` helper. I removed the `if (dest.writableNeedDrain === true) { pause(); } else` branch. The code is back to `if ((state[kState] & kFlowing) === 0) { src.resume(); }`, which is the pre-fix behaviour.

The other fix hunks (the `writableNeedDrain` getters in writable.js, duplex.js and _http_outgoing.js, and the check in pipeline.js) are left as they are. Reverting only the pipe hunk is enough to bring the bug back, and it keeps the change minimal.

**Failing test:** `parallel/test-stream-pipe-needDrain` reports `not ok` on both runs. The test sets `w.write = common.mustNotCall()`, and with the change `pipe` resumes the source and calls `w.write`. I only checked the TAP "not ok" line, not the exact failure message.
