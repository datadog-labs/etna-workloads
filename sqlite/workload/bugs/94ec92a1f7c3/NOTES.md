repro.sql loads the corrupt FTS4 database from fts3corrupt4 test 8.0 (via `.open --hexdb`) and runs `SELECT matchinfo(t1,'x') FROM t1 WHERE t1 MATCH 'e*'` (test 8.1).
Clean shell: "database disk image is malformed" (exit 1). Buggy shell: assertion failure `iDelta>0 || ...` in sqlite3Fts3SegReaderStep (abort, exit -6).
