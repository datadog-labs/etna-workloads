repro.sql loads the corrupt FTS5 database from fts5corrupt5-1.0 (`.open --hexdb`) and runs the 1.1 query (`ORDER BY rowid DESC` on `t1('R*')`).
Clean shell: `fts5: corruption on page 10, segment 2, table "t1"`, exit status 1.
Buggy shell: no error, exit status 0. The bounds check on the leaf's first-rowid offset in fts5SegIterReverse is missing, so it reads past the page.
