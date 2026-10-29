repro.sql builds the fts5aux-9.1 table and runs the 9.3 query, `SELECT rowid FROM t1('b:a AND b:b') ORDER BY rank`.
Clean returns 9, 10. Buggy returns 10, 9.
The injection removes the column filter copy in sqlite3Fts5ExprClonePhrase(). bm25() uses xQueryPhrase(), so it ignores the `b:` filter and ranks with wrong statistics.
