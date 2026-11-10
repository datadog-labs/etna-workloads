# Rationale

**Bug:** In `fileHandle.read({ position: 0 })` a position of `0` was treated as falsy and replaced by `null` (current file position), so zero positional reads were not respected after the file position had moved.

**Hunk (lib/internal/fs/promises.js, `read()`):** The upstream fix changed `bufferOrOptions.position || null` to `?? null`. The code has since been rewritten to use destructuring defaults (`position = null`), which preserves 0. I re-added the old behaviour by inserting `position = position || null;` after the options destructuring, so a `0` position collapses to `null` again.

**Failing test:** `parallel/test-fs-promises-file-handle-read` (not ok; reads at position 0 return the wrong data/bytes after the position moved).
