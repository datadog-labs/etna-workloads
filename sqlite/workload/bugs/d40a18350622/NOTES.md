repro.sh feeds the shell the fts5optimize2 test: an fts5 table with pgsz=32, then 1100 rounds of
two INSERTs plus INSERT INTO t1(t1) VALUES('optimize'), then SELECT count(*) FROM t1('mno').

Clean: prints 1100. Buggy: from about round 1000 the structure level count exceeds FTS5_MAX_LEVEL,
so every statement fails with "fts5: corrupt structure record for table "t1"" (output trimmed to
3 lines with head).
