# Rationale

Changed hunk: `src/backend/commands/tablecmds.c`, `ATExecDropConstraint()`.
Removed the block that returns early for partitioned tables when the constraint is neither CHECK nor NOT NULL.
This traces to the last hunk of fix_impl.patch (the "For partitioned tables, non-CHECK inherited constraints are dropped via the dependency mechanism" early return).

Why this brings the bug back: without the early return, dropping an inherited FK on a partitioned table (for example `fk_part_1.fkey` after detach) falls into the child-recursion code.
That code only handles CHECK and NOT NULL constraints, so it errors on the child FK `my_fkey`.
The drop that should succeed after detach therefore fails.

The other hunks of fix_impl.patch are already equivalent in REL_18_6 and cannot reproduce the bug on their own.
I tried reverting the `conislocal` condition in `ConstraintSetParentConstraint` and the FK `connoinherit` setting. Both are behaviorally equivalent in current code, and the oracle still passed with them reverted, so I didn't keep them.

Failing oracle case: src/test/regress||foreign_key
