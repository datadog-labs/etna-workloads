# Re-introduced bug: readdir recursive (withFileTypes) loops over the wrong length

**Bug.** With `withFileTypes`, the binding returns `[names, types, ...]`. The pre-fix code looped to `readdirResult.length`
(the number of arrays, i.e. 2) instead of the length of the names array. Entries were therefore skipped or left as
raw values with `name === undefined`.

**Hunks** (the release moved the code into `lib/internal/fs/utils.js`):
1. `collectRecursiveReaddirResult` (used by the permission-model sync and callback paths) now takes the whole result
   and loops to `result.length` when `withFileTypes`. This corresponds to the fix's `for (i < readdirResult.length)`
   vs `readdirResult[0].length`. The test does not exercise this path, because the permission model is off.
2. `getRecursiveDirents` (the default sync/callback path) uses `end = counts[d]` instead of `i + counts[d]`. This is
   the same kind of wrong loop bound as the fix's `length` change. Entries after the first directory are not
   converted to `Dirent`s, so their `name` is undefined.

**Failing test.** `sequential/test-fs-readdir-recursive` reports `not ok`. The fix's added assertions
(`dirents.length`, `dirent.name !== undefined`) catch it. It failed on two consecutive runs.
