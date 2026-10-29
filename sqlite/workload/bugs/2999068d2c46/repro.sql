.unmodule fts3
CREATE VIRTUAL TABLE t1 USING fts4(x);
SELECT name FROM sqlite_master;
