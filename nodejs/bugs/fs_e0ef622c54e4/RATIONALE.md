# Re-introduced bug: opendir recursive ignores bufferSize

**Bug.** In recursive mode, each sub-directory handle was read only once (up to `bufferSize` entries) and then closed, so with a small `bufferSize` (e.g. 1) most entries of sub-directories were silently dropped.

**Change (lib/internal/fs/dir.js, `#processHandlerQueue`).** Corresponds to the fix's single hunk in dir.js. The fix made the sub-directory handle be read until exhausted. In today's code that is done by re-pushing the handler onto `#handlerQueue` while reads return entries. I removed the re-queue and always close the handle after one read. That restores the pre-fix behaviour: one `bufferSize`-limited read per sub-directory.

**Failing test.** `sequential/test-fs-opendir-recursive` fails (stable across runs):
`AssertionError: Expected values to be strictly equal: 109 !== 169` at `assertDirents` (called from `processDirSync`, bufferSize: 1 case).
