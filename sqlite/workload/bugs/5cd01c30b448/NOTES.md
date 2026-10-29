repro.sql builds the fts5 trigram table (detail='none') from fts5trigram2-5.0 and runs
`SELECT rowid FROM t5 WHERE c1 LIKE 'abc%xyxz'`.
Clean shell prints `2`. Buggy shell aborts (exit -6) on the assertion in
sqlite3Fts5ParseImplicitAnd (pRight->eType may be FTS5_AND when bPhraseToAnd is set).
