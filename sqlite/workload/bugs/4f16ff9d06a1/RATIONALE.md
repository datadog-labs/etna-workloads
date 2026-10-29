# Rationale

## src/pragma.c, PRAGMA foreign_key_check
Reverses the single pragma.c hunk of the fix. The fix moved the register-count
increase (`nMem = regRow+pFK->nCol`) to *before* the loop that calls
`sqlite3ExprCodeGetColumnOfTable()`. In 3.54.1 that increase is spelled
`sqlite3TouchRegister(pParse, regRow + pFK->nCol)`; I moved it back to after the
loop (as `regRow+j`, where j==nCol), which is the pre-fix placement. The
equivalent final nMem is the same, but it is raised too late for the assert in
`sqlite3ExprCode()` (`target<=pParse->nMem`) while coding a generated column.

## Oracle failure
fkey1-7.2 (`CREATE TABLE t1(a,b,c AS(1),d, FOREIGN KEY(c,d,b,a,b,d,b,c) REFERENCES t0)`
then `PRAGMA foreign_key_check`) aborts with
`sqlite3ExprCode: Assertion 'target>0 && target<=pParse->nMem' failed`.
