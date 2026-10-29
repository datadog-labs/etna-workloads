# Rationale

Fix (ticket #3078) added two checks to `sqlite3_blob_open()` in `src/vdbeblob.c`, rejecting virtual tables and views.

Changes in `tree/src/vdbeblob.c`:
- Removed the `IsVirtual(pTab)` check ("cannot open virtual table: %s"). This reverses the first fix hunk. In 3.54.1 it sits among newer checks (without rowid, generated columns), which are left intact.
- Removed the `IsView(pTab)` check ("cannot open view: %s"). This reverses the second hunk. `IsView` is today's spelling of `pTab->pSelect`.

Oracle results: `incrblob-4.11` (view) crashes the testfixture with the assertion `i<nCol` in `sqlite3ColumnIndex`, because blob_open now proceeds on a view. The run aborts there, so 4.12 (virtual table) never runs. Without the check it would also fail, since the expected error message would be missing.
