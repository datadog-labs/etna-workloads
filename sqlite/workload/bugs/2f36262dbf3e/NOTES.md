repro.sql loads the corrupt FTS5 database from fix.patch's test 23.0 (via `.open --hexdb`) and runs `INSERT INTO t1(t1) VALUES('optimize')`.
Clean shell: reports an fts5 corruption error (exit 1). Buggy shell: the assert() in fts5WriteAppendRowid fails (abort, exit -6).
