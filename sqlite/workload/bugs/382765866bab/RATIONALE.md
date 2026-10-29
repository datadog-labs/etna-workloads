# Rationale

Fix hunk (src/where.c, exprAnalyze, OR->IN conversion): the fix replaced a
synthesized bare `TK_COLUMN` (built from `iCursor`/`iColumn`) as the IN's left
operand with a duplicate of the OR terms' actual left expression (`pLeft`).

In 3.54.1 the same code lives in `exprAnalyze`'s `okToChngToIN` block in
`src/whereexpr.c`. I reverted the single line
`pDup = sqlite3ExprDup(db, pLeft, 0);` to the pre-fix form: allocate a bare
`TK_COLUMN` with `iTable=iCursor` and `iColumn=iColumn` (via `sqlite3ExprAlloc`).
The synthesized column loses the original expression (collation, table
pointer, expression-index terms), as the old code did. The later collation
handling in the same block is left unchanged.

Oracle: with assertions enabled, `sqlite3ExprCollSeq` hits
`Assertion p->y.pTab!=0` on the first OR->IN conversion (where2-6.1.1), so the
run aborts; 76 of 104 oracle cases fail (all after where2-6.1.1 incomplete).
Note: setting `y.pTab` on the bare column made all oracle cases pass, so the
assertion crash is what the oracle detects.
