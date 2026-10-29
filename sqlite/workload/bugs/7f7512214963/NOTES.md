Reproducer (repro.sql): table t1 with a PRIMARY KEY index and an AFTER INSERT trigger that inserts into t1 itself (recursive triggers off); then DELETE, and INSERT INTO t1 SELECT FROM t2.

Clean: returns 4 rows (e, e+, g, g+) and integrity_check says "ok".
Buggy: the row "e+|f+" is lost (a stale per-VdbeCursor rowid cache is reused by the trigger's separate cursor on the same table), and integrity_check reports "wrong # of entries in index sqlite_autoindex_t1_1".
