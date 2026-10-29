# Notes

`repro.sql` creates an fts5 table and an `fts5vocab` table in `row` mode,
then runs `SELECT term FROM v WHERE term <= 1`.

The fts5vocab xFilter code uses the `<=` constraint argument (here the
integer `1`) as the upper bound ("LE term") for a range scan over terms.
The fix (upstream commit from 2019-01-18) added two guards:

- if the bound value's type is not `SQLITE_TEXT`, treat it as "no bound"
  (`pLe = 0`) instead of trying to use it as a term.
- if converting the bound value to text yields NULL (allocation failure
  path), fall back to an empty string instead of leaving a NULL pointer.

`injection.patch` removes both guards. With the guards gone, `pLe` is a
non-NULL column value that is not of type TEXT, so
`fts5VocabValueText()` returns `NULL` for it, and that `NULL` pointer is
then used directly as `pCsr->zLeTerm`'s source. The subsequent memcpy
(or later string comparisons against `zLeTerm`) dereferences the bad
pointer and crashes.

Result:

- `bin/sqlite3-clean`: exits 0, produces no rows (correctly, no term
  satisfies the comparison since the bound is not a usable text value).
- `bin/sqlite3-buggy`: crashes with SIGSEGV (exit status -11).

No table contents or inserts are needed — the crash happens while
setting up the cursor, before the empty table's data is ever scanned.
