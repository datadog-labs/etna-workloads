repro.sql loads the corrupt FTS5 database from fts5corrupt3 test 16.0 (via `.open --hexdb`) and runs `INSERT INTO t1(t1) VALUES('integrity-check')`.
Clean: `fts5: corrupt structure record for table "t1"` (pgnoLast<pgnoFirst is rejected when decoding the structure record).
Buggy: the check is missing, so it gets further and reports `fts5: checksum mismatch for table "t1"`.
