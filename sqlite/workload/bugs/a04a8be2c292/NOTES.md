repro.sql runs the orderby1-9.0 case: a scalar subquery using the block-sorting
optimization (ORDER BY x, y with x being the rowid of t1).
Clean shell prints `13`. The buggy shell, which lacks the early exit once the first
row is output, hits assertion `sqlite3BtreeCursorIsValid(pCur)` in sqlite3VdbeExec and aborts (exit -6).
