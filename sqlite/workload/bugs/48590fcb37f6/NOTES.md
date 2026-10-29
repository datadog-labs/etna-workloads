repro.sql creates t1(a) with rows NULL and 1, an index on the expression a+0, and runs
`SELECT ... WHERE a+0<10`. The clean shell returns only the row (1). The buggy shell also returns
the NULL row, because the range scan on an expression index no longer seeks past the leading NULL
entries (bSeekPastNull is not set for XN_EXPR).
