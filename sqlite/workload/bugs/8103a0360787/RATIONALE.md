# Rationale

Fix hunk reversed: `src/whereexpr.c` in `sqlite3WhereTabFuncArgs()`. The fix added
`if( pItem->fg.jointype & JT_LEFT ) sqlite3SetJoinExpr(pTerm, pItem->iCursor);`
so the implicit `hidden_col = arg` terms of a table-valued function on the right
side of a LEFT JOIN are marked as ON-clause terms. In 3.54.1 that code became an
unconditional `sqlite3SetJoinExpr(pTerm, pItem->iCursor, joinType)`, with
`joinType` chosen as `EP_OuterON` (LEFT/RIGHT) or `EP_InnerON`. I removed that
call and the now-unused `joinType` computation, which is the pre-fix state: the
argument terms are inserted without any join marking.

The other fix hunks only rename `setJoinExpr` to `sqlite3SetJoinExpr` and export it.
That is already the case in 3.54.1, so nothing needed changing.

Oracle failures (`tabfunc01.test`): `tabfunc01-751`, the ticket's LEFT JOIN of
two carray() table functions, and `tabfunc01-1200`. Without the join marking, the
argument constraints act as ordinary WHERE terms and give wrong LEFT JOIN results.
