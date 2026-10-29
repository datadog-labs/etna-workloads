# Rationale

## src/expr.c, impliesNotNullRow()
The fix added `case TK_VECTOR:` (and its `testcase`) to the group of ops that
return WRC_Prune (the "treat like TK_OR" group). In 3.54.1 that group still
contains TK_VECTOR, so reversing the hunk means removing `case TK_VECTOR:` and
its `testcase()` line from that switch. A row value such as `(c0, x'')` is then
walked into and its `c0` column is counted as proving the row non-null. This is
a false positive, because `(c0,x'') != (NULL,0)` can be true when c0 is NULL.
The LEFT JOIN is then wrongly strength-reduced to an inner join.

## Oracle failures
rowvalue-26.30 and rowvalue-26.31 fail. The LEFT JOIN with
`WHERE (c0, x'') != (NULL, 0)` returns no rows instead of the expected `3`.
