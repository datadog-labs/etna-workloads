# Rationale

## Change
`tree/src/whereexpr.c`, `exprAnalyze()`, vector `=`/`IS` decomposition loop (tag-20220128a): removed the call `transferJoinMarkings(pNew, pExpr);` after `sqlite3PExpr(...)`.

This reverses the single implementation hunk of the fix, which added that call so the virtual scalar terms made from `(a,b)=(x,y)` inherit the ON-clause markings (now EP_OuterON/EP_InnerON plus w.iJoin; then EP_FromJoin/iRightJoinTable). Without it, the derived terms are treated as WHERE-clause terms, so LEFT JOIN handling is wrong.

## Oracle failures
rowvalue-12.1, 12.2, 12.3 fail. They are the test the fix added: `SELECT *,'x' FROM t1 LEFT JOIN t2 ON (a,b)=(x,y)` should give `1 2 {} {} x` and no longer does.
