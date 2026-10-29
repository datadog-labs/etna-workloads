`repro.sql` loads the corrupt FTS5 database from test 22.0 of fts5corrupt3.test (via `.open --hexdb`) and runs `INSERT INTO t1(t1) VALUES('optimize')`.

- clean: `Error near line 325: fts5: corrupt structure record for table "t1"`, exit status 1.
- buggy: the missing corruption checks in fts5StructureDecode let the merge run, so it hits `Assertion 'pLvlOut->nSeg>0' failed` in fts5IndexMergeLevel and aborts (exit status -6).
