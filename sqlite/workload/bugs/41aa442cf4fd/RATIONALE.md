# Rationale

## Changed hunk: src/where.c, wherePathSatisfiesOrderBy()

Reverses the fix's `src/where.c` hunk. The fix replaced
`sqlite3ExprCollSeqMatch(pParse, ORDERBY-expr, pTerm->pExpr)==0` with a comparison of
the ORDER BY term's collation (`sqlite3ExprNNCollSeq`) against the collation the
==/IS comparison actually used (`sqlite3ExprCompareCollSeq`). In 3.54.1 that
code had since gained affinity checks, so a plain reverse of the patch does not
apply. I kept those and restored only the pre-fix collation test:
`sqlite3ExprCollSeqMatch()` on the ORDER BY expression and the whole comparison
expression. This compares the collation of the comparison expression itself, not
the one used by the comparison. The `pColl1`/`pColl2` locals and the assert were
removed along with it.

## Oracle failures (test/orderby5.test)
- orderby5-4.1.2: `WHERE b='abc' ORDER BY b COLLATE binary` on a NOCASE column. The
  ORDER BY term is wrongly treated as redundant, so rows come back in the wrong order.
- orderby5-4.2.2: the query plan lacks a temp b-tree for ORDER BY, which the test expects.
