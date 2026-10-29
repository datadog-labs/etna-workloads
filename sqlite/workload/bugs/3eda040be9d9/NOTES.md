repro.sql: creates t1(a INTEGER PRIMARY KEY, b TEXT), inserts (1,'01'), then runs
`INSERT INTO t1(b) SELECT b FROM t1` (the tkt1536-1.2 case) and selects b for rowid=2.
Clean shell prints `01`. Buggy shell applies table affinity to the ephemeral-table
record (injection in insert.c) and aborts with assertion
`zAffinity[0]==0 || pRec<=pLast` in sqlite3VdbeExec (exit status -6).
