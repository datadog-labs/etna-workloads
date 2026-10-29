Reproducer (repro.sql): creates u1/u2 (INTEGER PRIMARY KEY a, plus index u1ab(b,c)) and runs
EXPLAIN QUERY PLAN on `u2 LEFT JOIN u1 ON (u1.a=u2.a AND u1.b=u2.b AND u1.c=u2.c)` (join2-6.1).

Clean: prints `SCAN u2` (the LEFT JOIN is omitted), exit 0.
Buggy: assertion failure `iCol!=XN_ROWID || pProbe->uniqNotNull` in whereLoopAddBtreeIndex, abort (exit 134),
because the rowid pseudo-index no longer has uniqNotNull set.
