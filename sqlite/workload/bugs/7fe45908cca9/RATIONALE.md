# Rationale

Fix (ticket #3832, CVS 6583) hunk in `src/insert.c`: for a BEFORE trigger on an
INSERT whose IPK column value comes from a temp table (INSERT ... SELECT), the
fix applies the `OP_NotNull` / `OP_Integer -1` substitution to both the
temp-table and the expression paths. Before the fix, only the non-temp-table
path did.

Change in `tree/src/insert.c` (`sqlite3Insert`, the `tmask & TRIGGER_BEFORE`
block, was `regTrigRowid`, now `regCols`): moved the `OP_NotNull` /
`OP_Integer -1` / `JumpHere` back inside the `else` branch (the
`sqlite3ExprCode` path), so the `useTempTable` path (`OP_Column` from srcTab)
no longer maps a NULL IPK to -1. The NULL then reaches `OP_MustBeInt`.

Oracle: `tkt3832-1.1` fails with "datatype mismatch" (the original bug was a
segfault; today `OP_MustBeInt` turns the NULL into an error instead).
