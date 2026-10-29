# Rationale

## src/select.c (sqlite3Select, GROUP BY / ORDER BY-column handling)
Removed the `&& pBase->op!=TK_REGISTER` condition in the check guarding
`sqlite3ExprToRegister(pX, iAMem+j)`. This reverses the sole implementation hunk
of fix fcb669cfaa8a: the condition is still present in 3.54.1 (the surrounding
code gained a TK_IF_NULL_ROW loop, so the patch no longer applied textually, but
the line is equivalent). Without it, an expression already converted to
TK_REGISTER is converted again.

## Oracle failure
distinct2-5080 (the test the fix added) aborts:
`sqlite3ExprToRegister: Assertion 'p->iTable==iReg' failed`.
(The test run stops there, so later cases don't run.)
