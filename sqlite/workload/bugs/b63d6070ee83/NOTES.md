repro.sql loads the corrupt database from fts5corrupt3 test 11.0 (via `.open --hexdb`) and runs the UPDATE from test 11.1.
The corrupt structure record makes fts5 reuse a segment id that is already in use.
Clean shell: `constraint failed` (exit 1). Buggy shell: assertion failure in fts5AllocateSegid (`sqlite3_step(pIdxSelect)!=SQLITE_ROW`), abort.
