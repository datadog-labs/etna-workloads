# Rationale

Fix (ticket #1717, CVS 3137): CHECK constraints must honor the statement's
conflict-resolution algorithm (OR IGNORE / FAIL / ROLLBACK) instead of always
aborting. The fix's single implementation hunk, in `sqlite3GenerateConstraintChecks`
(src/insert.c), replaced a hard-coded `OP_Halt ... OE_Abort` with
`onError = overrideError!=OE_Default ? overrideError : OE_Abort`, plus an
IGNORE path (pop + goto ignoreDest).

## Change (tree/src/insert.c, CHECK section)
`onError = overrideError!=OE_Default ? overrideError : OE_Abort;`
became `onError = OE_Abort;`. Today's code already has the IGNORE branch and
HaltConstraint(onError) structure, so forcing onError to OE_Abort reproduces the
pre-fix behaviour exactly: every CHECK failure aborts, the IGNORE branch is dead,
and FAIL/ROLLBACK are not honored.

## Oracle failures (test/check.test)
check-6.2, 6.3 (OR IGNORE now errors instead of skipping the row), 6.6, 6.8, 6.9,
6.11, 6.13, 6.14, 6.15 (follow-on effects: OR FAIL / OR ROLLBACK not honored,
so rows/transaction state differ).
