# Rationale

Bug: unlikely()/likelihood()/likely() wrongly passed through the affinity of
their first argument (ticket 0c620df60bffd9ef).

In upstream, the fix (a) stopped setting EP_Skip on these functions in
resolve.c and (b) made sqlite3ExprAffinity skip only EP_Skip (COLLATE) nodes.
Before the fix, EP_Skip on unlikely() made the affinity walk descend into the
function's first argument.

In 3.54.1 the EP_Skip flag is no longer set on unlikely() and the
sqlite3ExprSkipCollate asserts op==TK_COLLATE, so setting EP_Skip again would
trip unrelated asserts. Instead, one hunk in `src/expr.c` `sqlite3ExprAffinity`
adds a branch that, for EP_Unlikely nodes, continues into
`x.pList->a[0].pExpr`. This restores the pre-fix behaviour (affinity of the
wrapped argument is used), reversing fix hunks resolve.c (EP_Skip on unlikely)
and expr.c (affinity skipping unlikely).

Failing oracle cases: func3-5.40 and func3-5.41 (twice): e.g.
`SELECT unlikely(CAST(1 AS INT))=='1'` returns 1 instead of 0, because the
INTEGER affinity of the CAST is applied to the comparison.
