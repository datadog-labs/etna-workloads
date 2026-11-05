# Rationale

All changes are in src/backend/commands/tablecmds.c; they trace to the tablecmds.c hunks of fix.patch.

1. `MergeConstraintsIntoExisting`, `if (!found)` block: removed the `CONSTRAINT_NOTNULL` branch.
   This is the reverse of the fix hunk that added it. A missing not-null constraint on the child now
   reports "child table is missing constraint ..." instead of "column ... in child table must be marked NOT NULL".

2. `MergeAttributesIntoExisting`: the fix rewrote the "parent has not-null, child must too" check.
   That check added the `HeapTupleIsValid(contup)` guard and the new comment. I removed the
   whole check, not just the guard. Reversing only the guard did not make the test fail,
   because the check still caught the case. With the check gone, the not-null case falls through to hunk 1's
   code path, and the wrong message appears.

Failing oracle case: src/test/regress||constraints
