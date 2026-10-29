## What it does

`repro.sql` runs test `zipfile-25.0` as plain SQL: it joins the `zipfile()`
table-valued function against a two-row CTE. The first row holds a valid
one-entry zip archive (as a hex blob decoded by `unhex`); the second row is
the single byte `'x'`, which is not a zip archive at all.

When `zipfile()` is invoked once per outer row, the cursor used for the first
(valid) row finishes normally and frees its list of "free" entries
(`pCsr->pFreeEntry`) via `zipfileResetCursor()`. The fix added a line to
reset `pCsr->pFreeEntry = 0` after freeing that list, because the same
cursor object is reused for the second row. Without that reset, the second
row's call into `zipfileFilter`/`zipfileNext` sees a dangling
`pFreeEntry` pointer from the already-freed list and walks/frees it again.

## Observed difference

- `bin/sqlite3-clean` (with the fix): produces the expected error
  `cannot open file: x` for the second row (matching the test's expected
  catchsql result), then stops at that error.
- `bin/sqlite3-buggy` (bug re-introduced): reuses the stale freed entry list
  on the second row and corrupts the heap, aborting with SIGABRT (exit
  status -6) instead of the clean error message. The exact abort message
  varies run to run (observed both `free(): double free detected in tcache 2`
  and an internal assertion failure), since it depends on heap state, but the
  abort/crash itself and the non-zero/signal exit status are consistent.
