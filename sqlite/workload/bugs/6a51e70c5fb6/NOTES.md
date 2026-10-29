Reproducer: `SELECT * FROM sqlite_temp_schema, sqlite_dbpage;` on an empty :memory: db (dbpage-300).
Clean shell: no output, exit 0. Buggy shell: assertion failure `pX!=0` in sqlite3VdbeExec, exit 134.
Cause: sqlite3VtabWriteAll sets the write mask without opening a write transaction on the temp database.
