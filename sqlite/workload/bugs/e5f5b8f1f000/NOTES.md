repro.sql: table t2(a,b) with index on (a,b) and a NULL in b for a=1; runs
`SELECT min(b) ... WHERE a=1 AND b>1` and `... b>-1`.
Clean prints 2 and 1. Buggy makes the min() scan stop at the NULL entry (bStopAtNull),
so it returns no matching rows/an empty result instead of 2 and 1.
