# Rationale

**Bug:** recursive `fs.readdir` with `withFileTypes: true` did not descend into symlinks that point to directories (a Dirent from a symlink has isDirectory() false, and only `isDirectory()` entries were queued). The result therefore had fewer entries than the same call with `withFileTypes: false`, which does follow them (issue #52663).

**Change (src/node_file.cc only):** the fix's hunk in `readdirSyncRecursive` (an extra stat of each entry so symlinks to directories get queued) now lives in the native walker `RecursiveReadDir::Scan`, which follows a `UV_DIRENT_LINK` with `uv_fs_stat` and sets `is_dir`. I added a `follow_links` flag (constructor, `Scan`, and the two call sites). It is `!with_types`. With file types, symlinked directories are no longer followed, which restores the pre-fix behaviour. Without file types, behaviour is unchanged.

**Failing test:** `parallel/test-fs-readdir-types-symlinks` fails with `AssertionError: Expected values to be strictly equal: 2 !== 4` (withFileTypes gives 2 entries, withoutFileTypes gives 4).
Note: `parallel/test-fs-readdir-recursive` also fails with this change, since it expects symlinks to be followed.
