# Rationale

Bug: a Duplex created with `readable: false` / `writable: false` only set the public `readable`/`writable` flag and did not mark the underlying stream state as ended/finished. So push()/write() on a disabled side was accepted instead of erroring (ERR_STREAM_PUSH_AFTER_EOF / ERR_STREAM_WRITE_AFTER_END), and async iteration/`end` could still happen.

Hunks:
- lib/internal/streams/duplex.js (fix hunk in Duplex constructor): replaced setting `_readableState.readable/ended/endEmitted` and `_writableState.writable/ending/ended/finished` with the old `this.readable = false` / `this.writable = false`.
- lib/internal/streams/destroy.js (fix hunk in undestroy): reset `ended/endEmitted/ending/finished` unconditionally to false instead of preserving `readable === false` / `writable === false`.

The other fix hunks (tty, child_process, http2, tests) do not apply/are not needed to restore the defect in the Duplex path; they were not reverted.

Failing test: parallel/test-stream-duplex-readable-writable (fails stably; the disabled side no longer emits the expected error).
