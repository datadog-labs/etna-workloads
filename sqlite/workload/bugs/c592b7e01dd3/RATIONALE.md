# Rationale

All changes are in `tree/src/alter.c`.

1. `getConstraint()` loop-exit condition: removed `t==TK_FOREIGN`. This reverses the fix hunk that added FOREIGN to the token list. Without it, the scan for the end of a constraint runs past a following `FOREIGN KEY` clause, so the FOREIGN KEY constraint is swallowed along with the dropped one.
2. `dropConstraintFunc()`: removed `t==TK_DEFAULT || t==TK_COLLATE` from the `t==TK_CONSTRAINT ...` test. This reverses the second code hunk. After a named constraint, a following DEFAULT or COLLATE is no longer treated as the start of another constraint.

The surrounding code now also has TK_AS/TK_GENERATED conditions. Those are unrelated and were left untouched.

## Failing oracle cases
altercons2-6.1, 6.2 (DEFAULT/COLLATE after a named constraint) and altercons2-7.1, 7.2 (CHECK followed directly by FOREIGN KEY). The statement either errors or leaves the wrong schema SQL.
