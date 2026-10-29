repro.sql: creates an fts5 table with two fts5vocab ('row') tables over it, inserts a row in an open transaction, and cross-joins the vocab tables.
Clean shell returns 4 rows (x|x, x|y, y|x, y|y); buggy returns only 2 (x|x, x|y), because the injection removes the `bEof = 0` reset in the vocab cursor's filter, so the inner scan stays at EOF after the first outer row.
