# Rationale

Fix hunk (src/where.c, whereRangeVectorLen): replaced
`sqlite3BinaryCompareCollSeq(pParse, pLhs, pRhs)` with
`sqlite3ExprCompareCollSeq(pParse, pTerm->pExpr)`, so the collation of a
row-value comparison term comes from the comparison expression itself.

In 3.54.1 the code instead had `if( ExprHasProperty(pTerm->pExpr, EP_Commuted) ) SWAP(Expr*, pRhs, pLhs);`
before the `sqlite3BinaryCompareCollSeq(pParse, pLhs, pRhs)` call, which compensates for commuted terms.
I removed that SWAP line, restoring the pre-fix state: the collation is computed from pLhs/pRhs
in the wrong operand order when the term was commuted, so the wrong collation (the
index column's, not the one the comparison actually uses) is checked against the index
collation, and the vector range constraint is wrongly used on the index.

Oracle: rowvalueA-3.3 fails (query with index x1a on x1(a) and `(1234, x2.y) > (x1.a, x1.b)`
returns wrong result because a NOCASE index range is used for a BINARY comparison).
