repro.sql: runs `SELECT (1,2,3,max(x)) IN () FROM t1` and `(1,2,max(x),3)` over a 3-row table.
Clean shell: aggregate query, so one row (0) per SELECT. Buggy shell: the aggregate property is
only propagated from the first vector element, so the query isn't treated as aggregate and
returns three rows per SELECT (6 lines instead of 2).
