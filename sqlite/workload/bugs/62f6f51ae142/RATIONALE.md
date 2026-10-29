# Rationale

## Changed hunk
`tree/src/where.c`, `wherePathSatisfiesOrderBy()`: the collation check after an
ORDER BY term matches an index column was `if( iColumn!=XN_ROWID ){`; it is
now `if( iColumn>=0 ){`.

This reverses the fix's only implementation hunk (`iColumn>=0` ->
`iColumn!=XN_ROWID`). The surrounding code was refactored (`sqlite3ExprNNCollSeq`),
but the condition is the same. With `iColumn>=0`, index-on-expression columns
(`XN_EXPR`, -2) skip the collation comparison, so an ORDER BY/GROUP BY with a
different collation than the index is wrongly treated as satisfied by the index.

## Oracle failures (indexexpr2.test)
- 3.2.2: `ORDER BY substr(x,2) COLLATE nocase` wrongly uses index i2 (BINARY), giving the wrong row order.
- 3.3.3: the EXPLAIN QUERY PLAN no longer shows `USE TEMP B-TREE FOR GROUP BY`.
- 3.4.6: the collation mismatch on an expression index gives wrong output or plan.
