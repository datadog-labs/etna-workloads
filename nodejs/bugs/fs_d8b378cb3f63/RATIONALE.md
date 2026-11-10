# Re-introduced bug: recursive opendir with unknown dirent types (fix d8b378cb)

**Bug.** `Dir` buffered entries were built with `getDirent(join(dir, name), name, type)`, so
`Dirent.parentPath` was the path of the entry itself, not of its containing directory. The
recursive walk then reused that "path" as the directory to open. When libuv reports
`UV_DIRENT_UNKNOWN`, the follow-up `lstat` joins `path` and `name` again. The old
`join()` shortcut `basename(path) === name ? path : join(path, name)` then resolves the wrong
file when a directory contains an entry with the same name as itself (`a/a`).

## Hunks
1. `lib/internal/fs/dir.js` `#processReadResult`: pass `pathModule.join(path, result[i])` as the
   dirent path again. This matches the fix's first hunk (`getDirent(path, ...)` replacing
   `getDirent(join(path, result[i]), ...)`).
2. `lib/internal/fs/dir.js` `#readSyncRecursive`: use `const path = dirent.parentPath;` instead of
   `join(dirent.parentPath, dirent.name)`. This matches the fix's `readSyncRecursive` hunk, and is
   consistent with hunk 1, where the dirent path is the entry path.
3. `lib/internal/fs/utils.js` `join()`: restore the `basename(path) === name ? path : ...` shortcut.
   This matches the fix's `utils.js` hunk.

## Result
`sequential/test-fs-opendir-recursive` fails (not ok) on every run. The deepStrictEqual of
`join(dirent.parentPath, dirent.name)` against the expected list shows the actual paths differing
from the expected ones (the entry name is duplicated). `sequential/test-fs-readdir-recursive`
still passes, because the readdir path does not go through `Dir`.
