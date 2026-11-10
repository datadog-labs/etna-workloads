# Re-introduced bug: Readable greedily reads after `_construct`

**Bug.** When a Readable has `_construct`, the construct callback unconditionally called `maybeReadMore`, so the stream started reading (calling `_read`) immediately after construction even if nobody had asked for data. For `fs.ReadStream` (and `process.stdin` from a file), this eagerly consumed data, so a child process inheriting stdin saw it already consumed.

**Hunk (lib/internal/streams/readable.js, `ReadableState.prototype[kOnConstructed]`).** Corresponds to the fix's hunk in `destroyImpl.construct(this, ...)` that wrapped `maybeReadMore` in `if (this._readableState.needReadable)`. In today's code that guard is `(this[kState] & kNeedReadable) !== 0`; I removed it so `maybeReadMore` runs unconditionally, as before the fix.

**Failing tests (with change).** parallel/test-stream-construct (`read: common.mustNotCall()` is invoked — construct causes a read) and parallel/test-stdin-from-file-spawn both report `not ok`.
