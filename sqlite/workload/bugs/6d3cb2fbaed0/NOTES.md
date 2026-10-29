Reproducer (`repro.sql`) is the fts3ac-6.1 case: an fts3 table with a row whose first column is empty, then `offsets()` on a MATCH.
Clean shell returns `1 0 0 3` and `0 0 0 3 1 0 0 3`. The buggy shell breaks out of the column loop early and then reports SQLITE_DONE as corruption, so the query fails with a corrupt-vtab error.
