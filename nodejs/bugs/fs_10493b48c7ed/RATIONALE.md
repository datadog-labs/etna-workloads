# Re-introduced bug: `length` ignored in `fh.read(options)`

**Bug:** `FileHandle.prototype.read({ buffer, offset, length, position })` ignored `length` in the options object and always read `buffer.byteLength - offset` bytes.

**Hunk:** `lib/internal/fs/promises.js`, `read()`. The fix changed `length = buffer.byteLength` to `length = bufferOrOptions.length ?? buffer.byteLength`. The code has since been refactored into destructuring, so the old behaviour is restored by removing `length` from the destructured options and setting `length = buffer.byteLength - offset` after it. This ignores the user's `length`, as before the fix.

**Failing test:** `parallel/test-fs-promises-file-handle-read`. `validateReadLength(0)` and `validateReadLength(1)` fail because `bytesRead` is not equal to the requested length (the whole 4-byte buffer is read).
