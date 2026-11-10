# Rationale

**Bug:** `Writable.prototype.end(chunk, ...)` wrote the final chunk via the public `this.write()`, discarding any error from the write (e.g. write-after-end). `end()` then went on to treat the stream as if it could be ended, so the error was not propagated correctly (the stream was not destroyed with ERR_STREAM_WRITE_AFTER_END synchronously, and the end callback saw a different error).

**Changes (lib/internal/streams/writable.js, `end`):**
1. Fix hunk "`const ret = _write(this, chunk, encoding); if (ret instanceof Error) err = ret;`" is reverted to `this.write(chunk, encoding)`, so the write error is dropped (old behaviour). `_write` helper is kept since `write` still uses it.
2. Fix hunk "`if (err) { // Do nothing... } else if (...)`" is reverted to just `if ((state[kState] & (kEnding | kErrored)) === 0)`, since `err` is no longer set from the write.

**Failing test:** `parallel/test-stream-writable-end-cb-error` fails (`not ok`, `code: 'ERR_ASSERTION'`) in two consecutive runs.
