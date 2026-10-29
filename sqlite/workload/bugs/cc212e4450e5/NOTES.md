Reproducer (repro.sql) is the where-28.1 case: a 13-column index on t1(b,...) plus
`UPDATE ... WHERE a IN (SELECT 15) AND b IN (1,2)`.
The injected bug shrinks WhereMemBlock.sz from u64 to u8, so large sqlite3WhereMalloc
blocks get a truncated size. Clean shell prints the correct rows (1|1, 15|999, 19|5);
buggy shell aborts with an assertion failure in sqlite3VdbeGetOp (exit -6).
