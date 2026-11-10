# Rationale

**Bug:** `fs.createReadStream` / `fs.createWriteStream` did not validate the `path` argument when no `fd` was given, so a non-string/Buffer/URL path (e.g. `46`) was accepted at construction instead of throwing `ERR_INVALID_ARG_TYPE` synchronously.

**Change (lib/internal/fs/streams.js):**
- Removed the `validatePath(this.path)` call in the `ReadStream` constructor, and the one in `WriteStream`. These correspond to the fix's added `validatePath(this.path)` else-branches in ReadStream/WriteStream (today's code places them inside the `options.fd == null` branch). Removing them restores the pre-fix lack of path validation.
- Removed the now-unused `validatePath` import (fix's import hunk).
- The fix's `options.fd != null` change in `importFd` and the `getValidatedFd` fd validation are already in a different form in today's code (importFd throws for non-number/FileHandle fds), so the fd test case still passes; not reverted.

**Failing test:** `parallel/test-fs-stream-options` -> `not ok` (the `path = 46` assertions: `fs.createReadStream(46)` does not throw, "Missing expected exception").
