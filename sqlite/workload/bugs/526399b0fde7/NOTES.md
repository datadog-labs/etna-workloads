Loads the corrupt FTS5 database from fts5corrupt3-83 (via `.open --hexdb`) and runs the 83.1 query with ORDER BY rowid DESC.
Clean: `Error near line 204: fts5: corruption found reading blob ...`, exit 1.
Buggy: assertion failure `*pConfig->pzErrmsg==0` in sqlite3Fts5ConfigErrmsg (abort, exit -6), because fts5SegIterReverse keeps going after an earlier error.
