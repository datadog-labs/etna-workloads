# Rationale

## src/expr.c, impliesNotNullRow()
The fix added `case TK_CASE:` to the list of node types that return WRC_Prune.
In 3.54.1 that label already exists in the same list (`TK_ISNOT ... TK_TRUTH, TK_CASE`),
so I removed `case TK_CASE:` and its `testcase()` line. CASE expressions are then
walked into again, so `CASE WHEN FALSE THEN a=x ELSE 1 END` is wrongly treated as
implying a non-NULL row of the LEFT JOIN's right table, and the LEFT JOIN is
strength-reduced to an inner join.

## Oracle failures
join-15.100 and join-15.110 fail (the tests the fix added). The other 197 cases pass.
