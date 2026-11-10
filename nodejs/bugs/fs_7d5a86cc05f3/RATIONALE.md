# Re-introduced bug: 'close' emitted twice with emitClose: true

**Bug.** fs streams had a backwards-compat path that manually emitted 'close' after the fd was closed.
With `emitClose: true` (the default for these streams) the stream machinery also emits 'close', so listeners fired twice.

**Change.** `lib/internal/fs/streams.js`, `_close()`: in the `fs.close` callback, after `cb(er || err)`, add `if (!er) stream.emit('close');`.

**Fix hunk correspondence.** The fix changed `closeFsStream` from `if (!er) stream.emit('close')` to `if (!er && !s.emitClose) ...`.
`closeFsStream` no longer exists in v26.13.0, and the fd-close callback is now `_close()`.
I put the unconditional manual emit there, without the `emitClose` guard. That is the pre-fix behaviour.

**Failing test.** `parallel/test-file-write-stream4` fails (`not ok`) on two runs. `common.mustCall()` on 'close' is called twice.
I did not capture the exact failure message text.
