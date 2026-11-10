# Re-introduced bug: writable.destroy() emitting more than the first error

**Bug.** If `writable.destroy()` is called with an error while the stream is already
destroyed but the `_destroy()` callback has not yet run, the new error was scheduled
for emission instead of being discarded. The stream then emitted `'kaboom 2'`
(the later error) rather than the first one (`'kaboom 1'`).

**Change (lib/internal/streams/destroy.js, `destroy()`).** The fix's first hunk
turned the already-destroyed branch into "emit err (once) if no error has been
emitted yet". Today's code has no such branch: it just calls `cb()` and returns,
discarding the error. I re-added the pre-fix behaviour: in the already-destroyed
branch, if there is no `cb` and `err` is set and `kErrorEmitted` is not set on
either state, `process.nextTick(emitErrorNT, this, err)`. As in the pre-fix code,
`errorEmitted` is not set eagerly, so a later error from the `_destroy()` callback
is not the one emitted. The fix's second hunk (guarding emission in the `_destroy`
callback) is already covered today by the guard in `emitErrorNT`, so no change was
needed there.

**Failing test.** `parallel/test-stream-writable-destroy` fails (stable over two runs):
`actual: 'kaboom 2', expected: 'kaboom 1'`.
