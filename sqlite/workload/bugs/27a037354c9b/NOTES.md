Reproducer (repro.sql): builds an fts5 table with two rows, turns off defensive mode, corrupts
the averages record (t1_data rowid=1, total row count 0), then runs a bm25 (`ORDER BY rank`) query.
Clean shell: error "database disk image is malformed" (xRowCount returns FTS5_CORRUPT).
Buggy shell: the removed check lets nRow=0 through, hitting the division by zero / assert in fts5Bm25GetData.
