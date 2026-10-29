Reproducer: with PRAGMA count_changes=1, `INSERT INTO t2 SELECT * FROM t1` should return the row count (2).
The buggy shell uses the xfer optimization, which skips the change-count result row, so it returns nothing.
