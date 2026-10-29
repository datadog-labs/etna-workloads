# Rationale

Fix hunks reversed (src/insert.c, sqlite3GenerateConstraintChecks, replace-trigger recheck):

1. `OP_IsNull, regIdx -> regIdx-1` (the off-by-one in partial index handling).
   In 3.54.1 `regIdx` is `aRegIdx[ix]+1` (first column register), whereas the
   record register tested is `aRegIdx[ix]` (= regIdx-1; NULL when the partial
   index does not apply). The pre-fix code tested one register before the
   intended one, so the equivalent today is `regIdx-2`.
2. Removed `VdbeCoverageIf(v, p2!=x.p2)` after copying the conflict-check opcode
   (the "missing VdbeCoverage" half of the fix); coverage-only, no behaviour change.

Oracle failure: insert-17.12 (REPLACE into t3 with partial index and delete
trigger) aborts with `Assertion memIsValid(&aMem[pOp->p3]) failed` in
sqlite3VdbeExec, since the IsNull tests a wrong/uninitialised register. Later
cases (17.13-17.15) are not reached.
