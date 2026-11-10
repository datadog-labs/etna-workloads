# Re-introduced bug: ZipProvider cannot rename implicit directories

**Bug.** `ZipProvider.rename()`/`renameSync()` only handled an exact archive entry. Renaming an
implicit directory (a prefix like `dir` for entries `dir/b.txt`) found no entry and threw ENOENT,
so the directory and its descendants were not moved.

**Change** (lib/internal/vfs/providers/ziparchive.js), corresponding to the fix's hunks:
- In `rename` and `renameSync`, the `entry === null` branch that called `getDirectoryRenames`
  (and the EINVAL check for moving a directory into itself) is replaced by the old
  `if (entry === null) throw createENOENT(...)` plus the EISDIR check and single-entry list.
  This restores the pre-fix behaviour of only renaming one exact entry.
- The `getDirectoryRenames` helper and the `createEINVAL` import are removed (hunks that the fix added),
  since they would otherwise be unused. `renameOptions` is kept (the release already differs here).

**Failing test.** `parallel/test-vfs-zip-provider` fails: `Error: ENOENT: no such file or directory, rename '/dir'`
thrown from `ZipProvider.rename`.
