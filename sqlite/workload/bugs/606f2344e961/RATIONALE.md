# Rationale

Fix hunk (src/select.c, setJoinExpr): added recursion into the argument list of
TK_FUNCTION nodes so ON-clause marking reaches function arguments.

In 3.54.1 this logic is `sqlite3SetJoinExpr()` in src/select.c. I removed the
`if( ExprUseXList(p) ){ ... sqlite3SetJoinExpr(p->x.pList->a[i].pExpr ...) }`
block, restoring the pre-fix behaviour: function arguments are not tagged with
EP_OuterON / w.iJoin. So `likelihood()`/`likely()` terms in a LEFT JOIN ON clause
are treated as ordinary WHERE terms and get evaluated early, dropping the
NULL-extended rows.

`unsetJoinExpr()` is left alone (it only undoes marks; with none set it is a no-op).

Failing oracle case: whereG-6.0 (`SELECT count(*) FROM t1 LEFT JOIN t2 ON likely(t1.i=t2.i) AND bool='T'` returns a count other than 4).
