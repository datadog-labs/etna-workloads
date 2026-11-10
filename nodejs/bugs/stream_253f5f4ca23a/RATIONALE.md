# Re-introduced bug: fromWritable().writev() leaks an internal cork

**Bug.** `fromWritable(writable).writev(chunks)` corks the wrapped Writable and then converts/writes each chunk. If converting a later chunk throws (e.g. `ERR_INVALID_ARG_TYPE` for `42`), `uncork()` is never called, so `writable.writableCorked` stays at 1 and the stream never flushes.

**Change (lib/internal/streams/iter/classic.js, `writev`).** In v26.13.0 `writev` calls `convertChunks()` up front, before corking, so the leak cannot happen. The fix's hunk made cork/write/uncork exception-safe (`try/finally`). I re-expressed the old behaviour for today's code:
- `writev` no longer converts before the capacity checks. It keeps `rawChunks`, and converts only in the queue/drop-newest branch (`convertChunks(rawChunks)`). The `chunks.length === 0` check became `chunks?.length === 0`.
- In the direct-write path, `writev` now corks the Writable, then calls `convertChunks(rawChunks)` outside any try/finally, then writes and uncorks manually. The manual uncork is reached on normal return and on a `write()` error, but not when conversion throws. This corresponds to the fix's hunk that wrapped the loop in `try { ... } finally { writable.uncork(); }`, and it restores the old cork-then-convert-then-uncork ordering without a finally.
- `writeBatch` (used for queued writes) is left as it was, since its chunks are already converted.

**Failing test.** `parallel/test-stream-iter-writable-interop` fails (checked twice) in `testWritevInvalidChunkUncorks`: `AssertionError: Expected values to be strictly equal: actual: 1, expected: 0`. That is `writable.writableCorked`.
