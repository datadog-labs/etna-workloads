# Re-introduced bug: FileHandle fd not reset after close

Bug: after `filehandle.close()`, the FileHandle kept reporting its old fd (and the native handle kept
its fd_), so later calls could operate on a recycled fd instead of failing with EBADF (nodejs/node#31361).

Hunks (the release already has the cached-fd/GetFD parts of the fix, so only the reset parts were reverted):
1. `lib/internal/fs/promises.js`, `close()`: removed `this[kFd] = -1;` (fix hunk: `this[kFd] = -1` in `close`). The JS fd stays at its old value after close.
2. `src/node_file.cc`, `FileHandle::AfterClose()`: removed `fd_ = -1;` (fix hunk: `fd_ = -1` in AfterClose). The native fd is no longer invalidated.

Failing test: parallel/test-fs-filehandle-use-after-close
`AssertionError: Expected values to be strictly equal: 17 !== -1` (filehandle.fd after close).
