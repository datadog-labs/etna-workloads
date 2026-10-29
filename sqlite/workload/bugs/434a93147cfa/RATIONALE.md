# Rationale

Changed `tree/src/where.c`, `wherePathSatisfiesOrderBy()`: removed the line
`if( mTerm==0 && !sqlite3ExprIsConstant(0,p) ) continue;`.

This reverses the fix's first `src/where.c` hunk, which added that check. Without it, an ORDER BY term that uses no tables (mTerm==0), such as `random()`, always counts as satisfied. The ORDER BY is then optimized out. The `mTerm` variable stays, since the later code uses it. It is equivalent to the pre-fix `(exprTableUsage(...)&~orderDistinctMask)==0`.

The fix's second hunk removed a block from `sqlite3WhereBegin`. That block is already gone in 3.54.1, so I left it alone.

Oracle cases that fail: where2-2.4, where2-2.5 and where2-2.5b. `ORDER BY random()` gets dropped, so repeated runs return identical order, EXPLAIN shows no `random` call, and no SorterOpen appears.
