# Rationale

## src/wherecode.c, codeAllEqualityTerms()
Reverses the fix hunk (`mallocFailed==0` -> `mallocFailed==0 && nErr==0`).
In 3.54.1 the guard had become `if( pParse->nErr==0 ){ assert(mallocFailed==0); ...`.
It is restored to the pre-fix `if( pParse->db->mallocFailed==0 ){`, so
sqlite3CompareAffinity()/sqlite3ExprAffinity() are again called on `pRight`
after a syntax error (the assert is dropped because it no longer holds).

## src/expr.c, sqlite3CodeSubselect()
By itself the wherecode.c revert does not fail anything on 3.54.1: the commit
message says "See also [e8a1515b44380cc5]", the earlier fix covering the same
defect. That fix is the code that, when sqlite3Select() fails on the subquery,
marks the expression `op = TK_ERROR` (saving `op2`), so affinity code never
treats the half-built TK_SELECT as valid. I removed those two lines (back to
a plain `return 0`). This is the same defect (affinity computed on a
subquery expression left inconsistent after a syntax error), covered by two
independent guards, and both must be reverted to restore the bug.

## Oracle
`window1-69.0` (`SELECT * FROM t1 WHERE b = (SELECT b FROM t1 ORDER BY lead(b) OVER () AND sum(a))`,
expected "misuse of aggregate: sum()") now aborts with
`sqlite3TableColumnAffinity: Assertion 0 failed` in testfixture; 69.1/69.2 are
the same shape and are lost with the aborted run.
