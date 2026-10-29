# Rationale

## Change: src/insert.c, sqlite3GenerateConstraintChecks (2-pass NOT NULL loop)
The fix added the call `sqlite3ComputeGeneratedColumns(pParse, regNewData+1, pTab)`
between the two NOT NULL passes, so that generated columns are recomputed after
NOT NULL ON CONFLICT REPLACE substituted a DEFAULT. The pre-fix code had no such
recompute. In 3.54.1 the 2-pass loop is still present, so I disabled only that
recompute (`if( 0 && nSeenReplace>0 && ... )`). Generated columns then keep values
computed from the pre-REPLACE (NULL) inputs.

## Oracle failures
test/gencol1.test gencol1-7.11 fails with the assertion
`memIsValid(&aMem[pOp->p3])` in sqlite3VdbeExec. The second-pass NOT NULL check on
the generated column reads a stale register. The other cases added by the fix
(7.12 through 7.51) guard the same defect: wrong or NULL generated values after REPLACE.
